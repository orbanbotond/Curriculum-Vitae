Prawn::Fonts::AFM.hide_m17n_warning = true

class CurriculumVitae < Prawn::Document
  require 'prawn'
  require 'prawn/table'

  def initialize(params = {})
    self.options = default_options.merge params

    super(page_size: options[:page_size], margin: Array.new(4, options[:margin]), compress: true)
    calculate_sidebar

    font_families.update("Georgian" => {
      :normal => File.join(File.expand_path(File.dirname(__FILE__)), "fonts","sans", "notogeorgian", "Regular.ttf"),
      :light => File.join(File.expand_path(File.dirname(__FILE__)), "fonts","sans", "notogeorgian", "Light.ttf"),
      :extra_bold => File.join(File.expand_path(File.dirname(__FILE__)), "fonts","sans", "notogeorgian", "ExtraBold.ttf"),
      :bold => File.join(File.expand_path(File.dirname(__FILE__)), "fonts","sans", "notogeorgian", "Bold.ttf"),
    })
    font "Georgian"

    self.image_path = "/Users/orbanbotond/Desktop/Profile\ x\ 300x300.png"
  end

  def draw
    draw_sidebar
    draw_page
    draw_vertical_for_work_experience
  end

private

  attr_accessor :options
  attr_accessor :image_path

  def default_options
    { show_bounds: false,
      margin: 24,
      leading: 25,
      page_size: 'A4',
      main_emphasized_color: "3A5180",
      sidebar_color: "40507D",
      main_color: "000000",
    }
  end

  def calculate_sidebar
    sidebar_ratio = 60.0 / 18
    side_bar_width = bounds.right / sidebar_ratio

    self.options = options.merge({
      sidebar_ratio: sidebar_ratio,
      side_bar_width: side_bar_width,      
    })
  end

  def show_bounds
    return unless options[:show_bounds]

    stroke_bounds
    stroke_axis color: 'FF0000'
  end

  def draw_sidebar
    save_graphics_state do
      canvas do
        fill_color( options[:sidebar_color] )
        fill_rectangle([0, bounds.top], options[:side_bar_width], bounds.top)
      end
    end
  end

  def title(text)
    text.upcase
  end

  def section(title)
    fill_color(options[:main_emphasized_color])
    pad_ratio = 2
    pad_top(options[:leading] / pad_ratio) do
      pad_bottom(options[:leading] / pad_ratio) do
        indent(20) do
          font "Georgian", style: :bold do
            text title(title),
                 size: 12,
                 align: :left
          end
        end
      end
    end

    font "Georgian", style: :light, size: 10, align: :justify do
      yield
    end
  end

  def sub_section(role, period, company)
    y_position = cursor
    width = bounds.right / 2

    bounding_box [0, y_position], width: width do
      show_bounds

      fill_color(options[:main_color])
      text role,
               size: 12,
               bold: true,
               align: :left
    end

    bounding_box [bounds.right / 2, y_position], width: width do
      show_bounds

      text period,
               size: 12,
               bold: true,
               align: :right
    end

    fill_color(options[:main_emphasized_color])
    pad_ratio = 6
    pad_top(options[:leading] / pad_ratio) do
      pad_bottom(options[:leading] / pad_ratio) do
        text company,
                 size: 12,
                 bold: true,
                 align: :justify
      end
    end

    pad_top(options[:leading] / pad_ratio) do
      pad_bottom(options[:leading] / pad_ratio) do
        fill_color(options[:main_color])

        yield
      end
    end

    move_down options[:leading] / (pad_ratio / 2)
  end

  def draw_page
    pad_ratio = 2

      bounding_box [options[:side_bar_width], bounds.top],
          width: bounds.right - options[:side_bar_width],
          height: bounds.top do
      show_bounds

      fill_color(options[:main_emphasized_color])

      font "Georgian", style: :extra_bold do
        text title("Botond Orbán"),
                     size: 22,
                     align: :center
      end

      pad_bottom(options[:leading] / pad_ratio) do
        text "Senior Ruby Developer - Contractor - Freelancer",
                   size: 12,
                   bold: true,
                   align: :center
      end

      stroke_color(options[:main_emphasized_color])
      stroke_horizontal_rule
      # move_down options[:leading]

      section("About Me") do
        fill_color(options[:main_color])
        text "Experienced senior software developer with 19 years of experience, also having strong experience in leadership and architect skills and experience. Demonstrated history of working in the capital markets industry. Constantly learning, polishing the knowledge, looking at new horizons."
      end
      section("Work Experience") do
        sub_section("Senior Developer", "Dec 2021 - Aug 2022", "Kwara") do
          text "The application wasn’t gaining serious subscribers due to the lack of security upon registration. Also it was struggling to gain new clients due to lack of visibility of the yearly Interest and Dividends across savings.", align: :justify
          text "• Making the application much more Secure by implementing a Multi Factor Authentication using 3rd party authenticator apps as the second factor."
          text "• Leveraging the network effect by giving the clients visibility over their Interests and Dividends based on their Savings by implementing a Dividend and Interest Calculator."
          text "Skills:  RoR Backend, API programming, Rspec, DryRb, Async Jobs, resolving n+1 query problem using distributed databases.", align: :justify
        end

        sub_section("Senior Developer", "Apr 2019 - Nov 2021", "Toptal") do
          text "The client was struggling to introduce new feature to the business due to the lack of maintanability of the monolithically organized application.", align: :justify
          text "• Reducing the tech debt and the cognitive effort of components by extracting the business domains from the monolyticall application into smaller services with 0 downtime and 0 bugs. Communicate the upcoming technical challenges like business concepts, clarify with the cross functional teams like devops, billing, stakeholders, then analyze the challenge, create spike tickets development tickets prioritize & implement constantly adjust with the extraction team, dockerize the extracted components, cover the new code with rspecs, ensure the CI cycle for the extracted components."
          text "Skills: RoR, Backend API programming, GraphQL, Apollo Federation, Async Jobs, Resolving N+1 query problems, Strong OO programming, Docker, Postgresql, Rspec, Google Cloud.", align: :justify
        end
      end
    end
  end

  def draw_vertical_for_work_experience
    bounding_box [options[:side_bar_width] - options[:margin] / 2.0 - 6/2, bounds.top],
          width: 6,
          height: bounds.top,
          margin: 0 do
      show_bounds

      stroke_color options[:main_emphasized_color]
      h = 560
      stroke_circle [3, h], 3
      fill_color options[:main_emphasized_color]
      fill_circle [3, h], 2
      stroke_line [3, h -3], [3, 320]
    end
  end
end

cv = CurriculumVitae.new()
cv.draw
cv.render_file("cv-prawn.pdf")
