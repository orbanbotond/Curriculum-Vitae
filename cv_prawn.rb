Prawn::Fonts::AFM.hide_m17n_warning = true

class CurriculumVitae < Prawn::Document

  class CvList
    def initialize(top_pading, doc)
      @top_pading = top_pading
      @doc = doc
    end

    def bullet
      @doc.float do
        @doc.bounding_box [0, @doc.cursor], :width => 10 do
          @doc.pad_top(@top_pading) do
            yield
          end
        end
      end
    end

    def content
      @doc.bounding_box [10, @doc.cursor], :width => @doc.bounds.right - 10 do
        @doc.pad_top(@top_pading) do
          yield
        end
      end
    end
  end

  require 'prawn'
  require 'prawn/table'

  def initialize(params = {})
    self.options = default_options.merge params

    super(page_size: options[:page_size], margin: Array.new(4, options[:margin]), compress: true)
    calculate_sidebar

    self.current_dir = File.expand_path(File.dirname(__FILE__))

    font_families.update("Georgian" => {
      :normal => File.join(current_dir, "fonts","sans", "notogeorgian", "Regular.ttf"),
      :light => File.join(current_dir, "fonts","sans", "notogeorgian", "Light.ttf"),
      :extra_bold => File.join(current_dir, "fonts","sans", "notogeorgian", "ExtraBold.ttf"),
      :semi_bold => File.join(current_dir, "fonts","sans", "notogeorgian", "SemiBold.ttf"),
      :bold => File.join(current_dir, "fonts","sans", "notogeorgian", "Bold.ttf"),
    })
    font "Georgian"
  end

  def draw
    draw_sidebar
    draw_vertical_line_for_work_experience( 0, 244, 419, 566)
    draw_page
    draw_vertical_line_for_work_experience( 0, 222, 444, 624, 785)
  end

private

  attr_accessor :options
  attr_accessor :current_dir

  def default_options
    { show_bounds: false,
      margin: 24,
      leading: 25,
      page_size: 'A4',
      main_emphasized_color: "3A5180",
      sidebar_color: "40507D",
      sidebar_text_color: "FFFFFF",
      main_color: "000000",
      side_bar_pad_ratio: 4,
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

  def draw_contact_info
    sidebar_section("Contact", "contact.jpg") do
      image File.join(current_dir, "assets", "phone.jpg"), at: [- 2, cursor - 1], width: 10
      indent(10) do
        pad_bottom(options[:leading] / options[:side_bar_pad_ratio]) do
          text "+40 741 182 213"
        end
      end

      image File.join(current_dir, "assets", "email.jpg"), at: [- 2, cursor - 1], width: 10
      indent(10) do
        pad_bottom(options[:leading] / options[:side_bar_pad_ratio]) do
          text "<link href='mailto:orbanbotond@gmail.com'>orbanbotond@gmail.com</link>", inline_format: true
        end
      end

      image File.join(current_dir, "assets", "location.jpg"), at: [- 2, cursor - 1], width: 10
      indent(10) do
        pad_bottom(options[:leading] / options[:side_bar_pad_ratio]) do
          text "Gheorgheni, Romania"
        end
      end

      image File.join(current_dir, "assets", "linkedin.jpg"), at: [- 2, cursor - 1], width: 10
      indent(10) do
        pad_bottom(options[:leading] / options[:side_bar_pad_ratio]) do
          text "<link href='https://www.linkedin.com/in/orbanbotond'>Botond Orban</link>", inline_format: true
        end
      end

      image File.join(current_dir, "assets", "skype.jpg"), at: [- 2, cursor - 1], width: 10
      indent(10) do
        pad_bottom(options[:leading] / options[:side_bar_pad_ratio]) do
          text "<link href='skype:orbanbotond?chat'>orbanbotond</link>", inline_format: true
        end
      end

    end
  end

  def draw_skill(skill, years)
    y_position = cursor
    width = bounds.right / 2
    years = years.end_with?('year') ? years + Prawn::Text::NBSP + Prawn::Text::NBSP : years

    bounding_box [0, y_position],
                 width: width do
      show_bounds

      text skill,
           align: :left
    end

    bounding_box [bounds.right / 2, y_position],
                 width: width do
      show_bounds

      text years,
           align: :right
    end
  end

  def sidebar_section(section, path_to_icon = nil)
    pad_top(options[:leading] / options[:side_bar_pad_ratio]) do
      pad_bottom(options[:leading] / options[:side_bar_pad_ratio]) do
        image File.join(current_dir, "assets", path_to_icon), at: [- 2, cursor + 2], fit: [20, 20] if path_to_icon
        indent(20) do
          text titleize(section),
               style: :bold,
               size: 12
        end
      end
    end

    pad_bottom(options[:leading] / options[:side_bar_pad_ratio]) do
      yield
    end
  end

  def sidebar_sub_section(subsection)
    pad_top(options[:leading] / options[:side_bar_pad_ratio]) do
      pad_bottom(options[:leading] / options[:side_bar_pad_ratio]) do
        text subsection,
             style: :bold
      end
    end

    yield
  end

  def draw_skills
    sidebar_section("Skills", "skills.jpg") do
      sidebar_sub_section("Backend") do
        draw_skill("Ruby", "14 years")
        draw_skill("RoR", "14 years")
        draw_skill("Sql", "24 years")
        draw_skill("PostgreSQL", "9 years")
        draw_skill("Mongo", "4 years")
        draw_skill("GraphQL", "5 years")
        draw_skill("Rest", "9 years")
        draw_skill("API", "9 years")

        draw_skill("Elastic", "6 years")
        draw_skill("Solr", "2 years")

        draw_skill("Kafka", "2 years")
        draw_skill("RabbitMq", "1 year")

        draw_skill("Docker", "6 years")
        draw_skill("Kubernetes", "2 years")
      end

      sidebar_sub_section("Frontend") do
        draw_skill("Javascript", "18 years")
        draw_skill("Turbo", "1 year")
        draw_skill("Hotwire", "1 year")
        draw_skill("Stimulus", "1 year")
        draw_skill("React", "5 years")
        draw_skill("Redux", "5 years")
        draw_skill("Backbone", "2 years")
        draw_skill("Bootstrap", "6 years")
        draw_skill("jQuery", "15 years")
      end
    end
  end

  def draw_education
    pad_ratio = 2

    sidebar_section("Education", "education.jpg") do
      text "Babeș-Bolyai University", style: :bold, align: :left
      font "Georgian", style: :light, size: 8 do
        text "Bachelor in Computer Science", align: :left
        text "Cluj-Napoca, 1998-2002", align: :left
      end

      pad_top(options[:leading] / pad_ratio) do
        text "Babeș-Bolyai University", style: :bold, align: :left
        font "Georgian", style: :light, size: 8 do
          text "Masters in Distributed Systems", align: :left
          text "Cluj-Napoca, 2002-2003", align: :left
        end
      end
    end
  end

  def draw_architecture
    sidebar_section("Architectures") do
      draw_skill("Crud", "12 years")
      draw_skill("Trailblazer", "5 years")
      draw_skill("CQRS/Event sourcing", "1 year")
    end
  end

  def draw_picture
    ratio = (8 / 10)
    width = options[:side_bar_width] - options[:margin] * 2
    xp = (options[:side_bar_width] - options[:margin] * 2 - width) / 2
    yp = bounds.top
    image File.join(current_dir, "assets", "profile.jpg"), at: [ xp , yp ], width: width
   
    x = xp + width / 2.0
    y = yp -width / 2.0

    stroke_color( options[:sidebar_text_color] )
    stroke_circle [x, y], width / 2 - 1

    stroke_color( options[:sidebar_color] )
    old_line_width = self.line_width
    self.line_width = options[:margin] 
    stroke_circle [x, y], (width + options[:margin]) / 2
    self.line_width = old_line_width
  end

  def draw_languages
    sidebar_section("Languages") do
      draw_skill("English", "Proeficient")
      draw_skill("Romanian", "Advanced")
      draw_skill("Hungarian", "Native")
    end
  end

  def draw_sidebar
    save_graphics_state do
      canvas do
        fill_color( options[:sidebar_color] )
        fill_rectangle([0, bounds.top], options[:side_bar_width], bounds.top)
      end
    end

    fill_color(options[:sidebar_text_color])

    width = options[:side_bar_width] - options[:margin] * 2

    bounding_box [0, bounds.top],
                 width: width,
                 height: bounds.top do
      draw_picture

      move_down 120

      font "Georgian", style: :light, size: 9, align: :justify do
        draw_contact_info
        draw_skills
        draw_education
        draw_languages
        # draw_architecture
      end
    end
  end

  def titleize(text)
    text.upcase
  end

  def section(title, path_to_icon)
    fill_color(options[:main_emphasized_color])
    pad_ratio = 2
    pad_top(options[:leading] / pad_ratio) do
      pad_bottom(options[:leading] / pad_ratio) do
        image File.join(current_dir, "assets", path_to_icon), at: [- 2, cursor + 2], fit: [20, 20]
        indent(20) do
          font "Georgian", style: :bold do
            text titleize(title),
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

    bounding_box [0, y_position], 
                 width: width do
      show_bounds

      fill_color(options[:main_color])
      text role,
           size: 12,
           style: :bold,
           align: :left
    end

    bounding_box [bounds.right / 2, y_position], 
                 width: width do
      show_bounds

      text period,
           size: 10,
           align: :right
    end

    fill_color(options[:main_emphasized_color])
    pad_ratio = 6
    pad_top(options[:leading] / pad_ratio) do
      pad_bottom(options[:leading] / pad_ratio) do
        text company,
             size: 12,
             style: :semi_bold,
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

  def draw_title
    pad_ratio = 2

    fill_color(options[:main_emphasized_color])

    font "Georgian", style: :extra_bold do
      text titleize("Botond Orbán"),
           size: 22,
           align: :center
    end

    pad_bottom(options[:leading] / pad_ratio) do
      text "Senior Ruby Developer • Contractor • Freelancer",
           size: 12,
           bold: true,
           align: :center
    end

    stroke_color(options[:main_emphasized_color])
    stroke_horizontal_rule
  end

  def list(top_pading = 0)
    yield CvList.new(top_pading, self)
  end

  def draw_page
    pad_ratio = 4
    bounding_box [options[:side_bar_width], bounds.top],
                 width: bounds.right - options[:side_bar_width],
                 height: bounds.top do
      show_bounds

      draw_title

      section("About Me", 'about_me.jpg') do
        fill_color(options[:main_color])
        text "I am a Ruby On Rails architect / contractor /freelancer with <b>19+ years of experience</b> only interested in remote work.", inline_format: true, align: :justify

        pad_top(options[:leading] / pad_ratio) do
          text "I use my expertise to identify & implement clients' needs concerning their software solutions. Constantly learning, polishing the knowledge, looking at new horizons.", align: :justify
        end

        pad_top(options[:leading] / pad_ratio) do
          text "<b>Drop me a message</b> if you think my expertise could help your organization!", inline_format: true, align: :justify
        end
      end

      section("Work Experience", 'work_experience.jpg') do
        sub_section("Senior Ruby Developer", "Aug 2023 - May 2024", "Ifad/United Nations") do
          text "The development of the project was stalled, gems were outdated. Adding new features was super risky and hard to do.", align: :justify

          list(options[:leading] / pad_ratio) do |list|
            list.bullet do
              text "•"
            end
            list.content do
              text "<b>Migrating the project to the latest Rails 7</b> by migrating the needed gems as well. Deploying to sandbox/staging/production by ensuring 0 downtime.", inline_format: true, align: :justify
            end
          end

          pad_top(options[:leading] / pad_ratio) do
            text "Skills:  RoR Backend, Strong OO, DDD, Rspec, DryRb, Async Jobs, resolving n+1 query problem. Devops.", align: :justify
          end
        end

        sub_section("Senior Ruby Developer", "Febr 2023 - July 2023", "Ifad/United Nations") do
          text "The old project completion reporting system wan't helping project stakeholders effectively with their reviews.", align: :justify

          list(options[:leading] / pad_ratio) do |list|
            list.bullet do
              text "•"
            end
            list.content do
              text "<b>Implemented a new PCR</b> by supporting both the new and old PCR in the same time for different projects. It consisted of mail, report, rating, reviewing and workflow alltogether. By doing this I introduces a new general feature versioning system for multiple versions of the same feature to be used systemwise.", inline_format: true, align: :justify
            end
          end

          pad_top(options[:leading] / pad_ratio) do
            text "Skills:  RoR Backend, Strong OO, DDD, Rspec, DryRb, Async Jobs, resolving n+1 query problem. Devops.", align: :justify
          end
        end

        sub_section("Senior Ruby Developer", "Dec 2021 - Aug 2022", "Kwara") do
          text "The application wasn’t gaining serious subscribers due to the lack of security upon registration. Also it was struggling to gain new clients due to lack of visibility of the yearly Interest and Dividends across savings.", align: :justify

          list(options[:leading] / pad_ratio) do |list|
            list.bullet do
              text "•"
            end
            list.content do
              text "<b>Secured the application</b> by implementing a Multi Factor Authentication using 3rd party authenticator apps as the second factor.", inline_format: true, align: :justify
            end
            list.bullet do
              text "•"
            end
            list.content do
              text "<b>Leveraged the network effect</b> by giving the clients visibility over their Interests and Dividends based on their Savings by implementing a Dividend and Interest Calculator.", inline_format: true, align: :justify
            end
          end

          pad_top(options[:leading] / pad_ratio) do
            text "Skills:  RoR Backend, API programming, Rspec, DryRb, Async Jobs, resolving n+1 query problem using distributed databases.", align: :justify
          end
        end

        start_new_page

        sub_section("Senior Ruby Developer", "Nov 2019 - Nov 2021", "Toptal") do
          text "The client was struggling to introduce new feature to the business due to the lack of maintanability of the monolithically organized application.", align: :justify

          list(options[:leading] / pad_ratio) do |list|
            list.bullet do
              text "•"
            end
            list.content do
              text "<b>Reduced the tech debt and the cognitive effort</b> by extracting the billing bounded context from the monolyticall application. Doing all this with <b>0 downtime and 0 bugs</b>.", inline_format: true, align: :justify
            end
          end

          pad_top(options[:leading] / pad_ratio) do
            text "Skills: RoR, GraphQL, Apollo Federation, Async Jobs, Resolving N+1 query problems, Strong OO programming, Docker, Postgresql, Rspec, Google Cloud.", align: :justify
          end
        end

        sub_section("Senior Ruby Developer", "Apr 2019 - Nov 2019", "SwoopMe Inc.") do
          text "The client was a B2B towing company having an inefficient biding algorythm.", align: :justify

          list(options[:leading] / pad_ratio) do |list|
            list.bullet do
              text "•"
            end
            list.content do
              text "<b>Maximized the profit</b> on the main geolocation based <b>biding algorythm</b> by assigning the towing opportunities to the nearest towing providers. Doing this with 0 bug and 0 downtime.", inline_format: true, align: :justify
            end
            list.bullet do
              text "•"
            end
            list.content do
              text "<b>Reduced the onboarding costs</b> of the new developers <b>to half day</b> dockerizing the whole development stack.", inline_format: true, align: :justify
            end
          end

          pad_top(options[:leading] / pad_ratio) do
            text "Skills: RoR, Backend API, Geolocation, Async Jobs, Resolving N+1 query problems, Strong OO programming, Docker, Postgresql, Rspec, Google Cloud.", align: :justify
          end
        end

        sub_section("Head Of Web Platform", "Jan 2018 - Sep 2018", "Globacap") do
          text "The client a newly founded startup also a trailblazing technology. Globacap’s vision is to tokenize the private markets for small and medium enterprises ang give them similar opportunities like they would be public companies.", align: :justify

          list(options[:leading] / pad_ratio) do |list|
            list.bullet do
              text "•"
            end
            list.content do
              text "<b>Architected</b> the platform from scratch using Trailblazer on top of RoR, allowing the company to raise its own funding and let the company into the UK financial conduct authority sandbox.", inline_format: true, align: :justify
            end
            list.bullet do
              text "•"
            end
            list.content do
              text "<b>Led a remote team of 6</b> developers in achieving the timeline and milestones of the project. Set up a code quality/deployment guards. Being responsible for the scrum process.", inline_format: true, align: :justify
            end
          end

          pad_top(options[:leading] / pad_ratio) do
            text "Skills: RubyOnRails, DryRb, Trailblazer, React, Flux, Bootstrap, PostgreSql, Docker, Heroku, AWS, System Architecture.", align: :justify
          end
        end

        sub_section("Full Stack Lead Developer", "Aug 2015 - Nov 2017", "Meeteor") do
          text "The client was a startup specializing itself on managing meetings.", align: :justify

          list(options[:leading] / pad_ratio) do |list|
            list.bullet do
              text "•"
            end
            list.content do
              text "<b>Reduced the page load speed from 12 seconds to 1.2 second</b> by introducing a custom DSL for field level caching of AR thus caching based only on what is displayed.", inline_format: true, align: :justify
            end
            list.bullet do
              text "•"
            end
            list.content do
              text "<b>Achieved a search accuracy of 95%</b> by introducing a full text search index for the tasks, learnings, decisions, notes similar to apple spotlight.", inline_format: true, align: :justify
            end
            list.bullet do
              text "•"
            end
            list.content do
              text "<b>Fixed security 100%</b> acrosss the tenants of the platform by implementing well tested policies for roles across the application.", inline_format: true, align: :justify
            end
          end

          pad_top(options[:leading] / pad_ratio) do
            text "Skills: RubyOnRails, Rspec, DryRb, ElasticSearch, MySql, JQuery, Javascript.", align: :justify
          end
        end
      end
    end
  end

  def double_circle(height)
    stroke_circle [3, height], 3
    fill_color options[:main_emphasized_color]
    fill_circle [3, height], 2
  end

  def draw_vertical_line_for_work_experience(*chain)
    bounding_box [options[:side_bar_width] - options[:margin] / 2.0 - 6/2, bounds.top],
                  width: 6,
                  height: bounds.top,
                  margin: 0 do
      show_bounds


      chain.each_cons(2).each do |a, b|
        stroke_color options[:main_emphasized_color]
        stroke_line [3, a + 3], [3, b - 3]
        double_circle(b)
      end
    end
  end
end

cv = CurriculumVitae.new()
cv.draw
cv.render_file("cv-orban-botond.pdf")
