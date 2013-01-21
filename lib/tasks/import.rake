namespace :db do
  require 'nokogiri'

  %w{lib/import}.each do |dir|
    Dir[Rails.root.join("#{dir}/**/*.rb")].each {|f| require f}
  end


  desc 'import the member data from the german XML export'
  task :import_from_xml, [:file_path] => [:environment] do |t, args|
    f = File.open(args[:file_path])
    doc = Nokogiri::XML(f)
    f.close

    multiple_districts = doc.xpath(".//MDISTRICT")
    size = multiple_districts.size

    puts 'Starting Import'
    multiple_districts.each_with_index do |md, index|
      begin
        year = md['year'].gsub(/\//, '-')
        obj = Import::MultipleDistrictFactory.new(md, year).build_model
        puts "file imported, now saving db entities"
        obj.save!
        puts "Imported #{index+1} of #{size} multiple districts"
        Setting.new(key: :max_ids).save!
        [MultipleDistrict, District, Club, Member].each{|e| e.set_max_id}
      rescue Exception => e
        puts "Error occured: (message: #{e.message})"
        puts "Backtrace:"
        puts e.backtrace.join '\n'
      end
    end
    puts 'Import finnished successfully'
  end
end