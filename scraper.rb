require "selenium-webdriver"
require "csv"

def get_fundamentus_info(driver, url, filename = "output.csv")
  puts "Iniciando arquivo #{filename} da url #{url}"
  driver.get(url)
  wait = Selenium::WebDriver::Wait.new(timeout: 15)
  wait.until do
    puts "dentro wait"
    header = driver.find_elements(css: "thead")
    tbody = driver.find_elements(css: 'tbody[aria-live="polite"]')
    rows = tbody.first.find_elements(css: "tr")
    # puts header.first.text
    puts "Pegando as info"


    header = header.first.text.gsub("\n", "\t")
    puts header #{header}
    CSV.open(filename, "w", write_headers: true, headers: header, col_sep: "\t") do |line|
      puts "Criando arquivo"
      rows.each_with_index do |row, index|
        puts "#{filename} - linha #{index}"
        line << row.find_elements(css: "td").map(&:text)
      end
    end

    puts "Arquivo gerado #{filename}"
  end
end

options = Selenium::WebDriver::Chrome::Options.new
options.add_argument("--headless")
options.add_argument('--disable-blink-features=AutomationControlled')
options.add_argument('--no-sandbox')
options.add_argument('--disable-dev-shm-usage')

driver = Selenium::WebDriver.for :chrome, options: options

get_fundamentus_info driver, "https://fundamentus.com.br/resultado.php?interface=classic&interface=mobile", "acoes.csv"
get_fundamentus_info driver, "https://fundamentus.com.br/fii_resultado.php?interface=classic&interface=mobile", "fiis.csv"

driver.quit
