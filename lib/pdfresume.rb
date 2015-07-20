require 'pdfkit'

class PDFResume < Middleman::Extension
  #alias :included :registered

  def initialize(app, options_hash={}, &block)
    super
    app.after_build do |builder|
      begin
        kit = PDFKit.new(File.new('build/resume.html'),
                         :margin_top => 10,
                         :margin_bottom => 0,
                         :margin_left => 0,
                         :margin_right => 0,
                         :print_media_type => true,
                         :dpi => 96)

        file = kit.to_file('build/resume.pdf')

      rescue Exception =>e
        builder.say_status "PDF Resume",  "Error: #{e.message}", Thor::Shell::Color::RED
        raise
      end
      builder.say_status "PDF Resume",  "PDF file available at build/resume.pdf"
    end
  end

end

::Middleman::Extensions.register(:pdfresume, PDFResume)
