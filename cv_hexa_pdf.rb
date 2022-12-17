require 'hexapdf'

composer = HexaPDF::Composer.new(page_size: :A4, margin: 72)

composer.style(:base, font: "Helvetica", font_size: 12, line_spacing: 1.2)

box = composer.page.box(:media)
composer.canvas.
  fill_color("77C3EC").
  rectangle(0, 0, box.width, 50).
  rectangle(0, box.height - 50, box.width, 50).
  fill

composer.text("HexaPDF Example Inc.\nGarnish Street 3a\n4567 New South East\nWorld",
              width: 150, height: 100, padding: 5, border: {width: 1},
              position: :float, position_hint: :right)

composer.text("Customer Here\nAvailability Arcarde 1\n 8901 Old North West\nMoon",
              width: 150, height: 100, padding: 5, border: {width: 1})

composer.text("Invoice 1234", font_size: 24, margin: [40, 0])

invoice_data = [
  ["Item", "Amount", "Total Price"],
]
1.upto(10) do |i|
  invoice_data << ["Super Dooper #{i}", i, "$ #{10*i}"]
end
invoice_data << ["", "", "$ 450"]

invoice_data.each_with_index do |row, rindex|
  row.each_with_index do |content, cindex|
    style = {height: 25, padding: 5, border: {width: 1}, margin: [0, -1, -1, 0], valign: :center}
    if rindex == 0 || rindex == invoice_data.length - 1
      style.update({font: ["Helvetica", variant: :bold], background_color: "EEE"})
    end
    case cindex
    when 0 then style.update(width: 250, position: :float)
    when 1 then style.update(width: 80, position: :float, align: :right)
    when 2 then style.update(align: :right)
    end
    composer.text(content.to_s, **style, )
  end
end

composer.draw_box(HexaPDF::Layout::Box.new(height: 40))

composer.formatted_text(
  ["Please transfer the money to the following bank account:\n",
   {text: "IBAN: ", font: ["Helvetica", variant: :bold]},
   "AT65 1234 1234 5678 9012 3456, ",
   {text: "BIC: ", font: ["Helvetica", variant: :bold]},
   "ABCDAT12345\n",
   {text: "Thank you for choosing us!", font: ["Helvetica", variant: :italic], font_size: 8}],
  align: :center
)

composer.write("invoice-hexapdf.pdf", optimize: true)
