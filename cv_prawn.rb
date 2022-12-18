require 'prawn'
require 'prawn/table'

Prawn::Fonts::AFM.hide_m17n_warning = true
image_path = "/Users/orbanbotond/Desktop/Profile\ x\ 300x300.png"

def init_fonts(doc)
  doc.font_families.update("Georgian" => {
    :normal => File.join(File.expand_path(File.dirname(__FILE__)), "fonts","sans", "notogeorgian", "Regular.ttf"),
    :light => File.join(File.expand_path(File.dirname(__FILE__)), "fonts","sans", "notogeorgian", "Light.ttf"),
    :extra_bold => File.join(File.expand_path(File.dirname(__FILE__)), "fonts","sans", "notogeorgian", "ExtraBold.ttf"),
    :bold => File.join(File.expand_path(File.dirname(__FILE__)), "fonts","sans", "notogeorgian", "Bold.ttf"),
  })
  doc.font "Georgian"
end

def show_bounds(doc)
  return unless $show_bounds

  doc.stroke_bounds
  doc.stroke_axis color: 'FF0000'
end


def draw_sidebar(doc)
  doc.save_graphics_state do
    doc.canvas do
      doc.fill_color( $sidebar_color )
      doc.fill_rectangle([0, doc.bounds.top], $side_bar_width, doc.bounds.top)
    end
  end
end

def title(text)
  text.upcase
end

def section(title, doc)
  doc.fill_color($main_emphasized_color)
  pad_ratio = 2
  doc.pad_top($leading / pad_ratio) do
    doc.pad_bottom($leading / pad_ratio) do
      doc.indent(20) do
        doc.font "Georgian", style: :bold do
          doc.text title(title),
                   size: 12,
                   # bold: true,
                   align: :left
        end
      end
    end
  end

  yield doc
end

def sub_section(role, period, company, doc)
  y_position = doc.cursor
  width = doc.bounds.right / 2

  doc.bounding_box [0, y_position], width: width do
    show_bounds(doc)

    doc.fill_color($main_color)
    doc.text role,
             size: 12,
             bold: true,
             align: :left
  end

  doc.bounding_box [doc.bounds.right / 2, y_position], width: width do
    show_bounds(doc)

    doc.text period,
             size: 12,
             bold: true,
             align: :right
  end

  doc.fill_color($main_emphasized_color)
  pad_ratio = 6
  doc.pad_top($leading / pad_ratio) do
    doc.pad_bottom($leading / pad_ratio) do
      doc.text company,
               size: 12,
               bold: true,
               align: :justify
    end
  end

  doc.pad_top($leading / pad_ratio) do
    doc.pad_bottom($leading / pad_ratio) do
      doc.fill_color($main_color)

      yield doc
    end
  end

  doc.move_down $leading / (pad_ratio / 2)
end

def draw_page(doc)
  pad_ratio = 2

      doc.bounding_box [$side_bar_width, doc.bounds.top],
          width: doc.bounds.right - $side_bar_width,
          height: doc.bounds.top do
      show_bounds(doc)

      doc.fill_color($main_emphasized_color)

      doc.font "Georgian", style: :extra_bold do
        doc.text title("Botond Orbán"),
                     size: 22,
                     # bold: true,
                     align: :center
      end

      doc.pad_bottom($leading / pad_ratio) do
        doc.text "Senior Ruby Developer - Contractor - Freelancer",
                   size: 12,
                   bold: true,
                   align: :center
      end

      doc.stroke_color($main_emphasized_color)
      doc.stroke_horizontal_rule
      # doc.move_down $leading


      section("About Me", doc) do | doc|
        doc.fill_color($main_color)
        doc.text "Experienced senior software developer with leadership and architect skills and experience. Demonstrated history of working in the capital markets industry. Constantly learning, polishing the knowledge, looking at new horizons.",
                     size: 12,
                     # bold: true,
                     align: :justify
      end
      section("Work Experience", doc) do |doc|
        sub_section("Senior Developer", "Dec 2021 - Aug 2022", "Kwara", doc) do |doc|
          doc.text "The application wasn’t gaining serious subscribers due to the lack of security upon registration. Also it was struggling to gain new clients due to lack of visibility of the yearly Interest and Dividends across savings.", align: :justify
          doc.text "• Making the application much more Secure by implementing a Multi Factor Authentication using 3rd party authenticator apps as the second factor."
          doc.text "• Leveraging the network effect by giving the clients visibility over their Interests and Dividends based on their Savings by implementing a Dividend and Interest Calculator."
          doc.text "Skills:  RoR Backend, API programming, Rspec, DryRb, Async Jobs, resolving n+1 query problem using distributed databases.", align: :justify
        end

        sub_section("Senior Developer", "Apr 2019 - Nov 2021", "Toptal", doc) do |doc|
          doc.text "The client was struggling to introduce new feature to the business due to the lack of maintanability of the monolithically organized application.", align: :justify
          doc.text "• Reducing the tech debt and the cognitive effort of components by extracting the business domains from the monolyticall application into smaller services with 0 downtime and 0 bugs. Communicate the upcoming technical challenges like business concepts, clarify with the cross functional teams like devops, billing, stakeholders, then analyze the challenge, create spike tickets development tickets prioritize & implement constantly adjust with the extraction team, dockerize the extracted components, cover the new code with rspecs, ensure the CI cycle for the extracted components."
          doc.text "Skills: RoR, Backend API programming, GraphQL, Apollo Federation, Async Jobs, Resolving N+1 query problems, Strong OO programming, Docker, Postgresql, Rspec, Google Cloud.", align: :justify
        end
      end
    end
end

def draw_vertical_for_work_experience(doc)
  doc.bounding_box [$side_bar_width - $margin / 2.0 - 6/2, doc.bounds.top],
        width: 6,
        height: doc.bounds.top,
        margin: 0 do
    show_bounds(doc)

    doc.stroke_color $main_emphasized_color
    h = 560
    doc.stroke_circle [3, h], 3
    doc.fill_color $main_emphasized_color
    doc.fill_circle [3, h], 2
    doc.stroke_line [3, h -3], [3, 320]
  end
end

$show_bounds = false
# $show_bounds = true
$margin = 24
$leading = 25
doc = Prawn::Document.new(page_size: "A4", margin: [ $margin, $margin, $margin, $margin ], compress: true)

puts doc.bounds.top
puts doc.bounds.top
puts doc.bounds.top
puts doc.bounds.right
puts doc.bounds.right
puts doc.bounds.right

$main_emphasized_color = "3A5180"
$sidebar_color = "40507D"
$main_color = "000000"
$sidebar_ratio = 60.0 / 18
$side_bar_width = doc.bounds.right / $sidebar_ratio

init_fonts(doc)
draw_sidebar(doc)
draw_page(doc)
draw_vertical_for_work_experience(doc)

doc.render_file("cv-prawn.pdf")

# doc.font("Helvetica")
# doc.font_size(12)

# doc.save_graphics_state do
#   doc.canvas do
#     doc.fill_color("77C3EC")
#     doc.fill_rectangle([0, 50], doc.bounds.right, 50)
#     doc.fill_rectangle([0, doc.bounds.top], doc.bounds.right, 50)
#     doc.fill_color("000000")
#   end
# end

# doc.float do
#   doc.bounding_box([doc.bounds.right - 150, doc.cursor], width: 150, height: 100) do
#     doc.stroke_bounds
#     doc.text_box("Prawn Example Inc.\nGarnish Street 3a\n4567 New South East\nWorld",
#                  at: [5, doc.bounds.top - 5], width: 140, height: 90)
#   end
# end

# doc.bounding_box([0, doc.cursor], width: 150, height: 100) do
#   doc.stroke_bounds
#   doc.text_box("Customer Here\nAvailability Arcarde 1\n 8901 Old North West\nMoon",
#                at: [5, doc.bounds.top - 5], width: 140, height: 90)
# end

# doc.move_down(40)

# doc.font_size(24) do
#   doc.text("Invoice 1234")
# end

# doc.move_down(40)

# invoice_data = [
#   ["Item", "Amount", "Total Price"],
# ]
# 1.upto(10) do |i|
#   invoice_data << ["Super Dooper #{i}", i, "$ #{10*i}"]
# end
# invoice_data << ["", "", "$ 450"]

# doc.table(invoice_data, width: doc.bounds.width,
#           cell_style: {padding: 5, height: 25}, column_widths: [250, 80]) do |table|
#   table.row(0).font_style = :bold
#   table.row(0).background_color = "EEEEEE"
#   table.row(-1).font_style = :bold
#   table.row(-1).background_color = "EEEEEE"
#   table.column(-2..-1).align = :right
# end

# doc.move_down(40)

# doc.formatted_text(
#   [{text: "Please transfer the money to the following bank account:\n"},
#    {text: "IBAN: ", styles: [:bold]},
#    {text: "AT65 1234 1234 5678 9012 3456, "},
#    {text: "BIC: ", styles: [:bold]},
#    {text: "ABCDAT12345\n"},
#    {text: "Thank you for choosing us!", styles: [:italic], size: 8}],
#   align: :center
# )

# doc.render_file("invoice-prawn.pdf")
