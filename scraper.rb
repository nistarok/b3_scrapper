require "selenium-webdriver"
require "csv"

def get_fundamentus_info(driver, url, filename = "output.csv")
  puts "Iniciando arquivo #{filename} da url #{url}"
  driver.get(url)
  wait = Selenium::WebDriver::Wait.new(timeout: 20)
  wait.until do
    ready_state = driver.execute_script('return document.readyState')
    ready_state == 'complete'
  end
  header = driver.find_elements(css: "thead")
  tbody = driver.find_elements(css: 'tbody[aria-live="polite"]')
  rows = tbody.first.find_elements(css: "tr")
  # puts header.first.text
  puts "Pegando as info"
  header = header.first.text.gsub("\n", "\t")
  CSV.open(filename, "w", write_headers: true, headers: header, col_sep: "\t") do |line|
    puts "Criando arquivo"
    rows.each_with_index do |row, index|
      puts "#{filename} - linha #{index}"
      line << row.find_elements(css: "td").map(&:text)
    end
  end

  puts "Arquivo gerado #{filename}"
end

options = Selenium::WebDriver::Chrome::Options.new
options.add_argument("--headless")
options.add_argument('--disable-blink-features=AutomationControlled')
options.add_argument('--no-sandbox')
options.add_argument('--disable-dev-shm-usage')
options.add_argument('user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36')
options.add_argument("--disable-infobars")  # Desabilita a barra de informações
options.add_argument("--disable-extensions")  # Desabilita extensões
options.add_argument("--disable-gpu")  # Desabilita aceleração de GPU
options.add_argument("--remote-debugging-port=9222")  # Habilita a depuração remota para análise


driver = Selenium::WebDriver.for :chrome, options: options

get_fundamentus_info driver, "https://fundamentus.com.br/resultado.php?interface=classic&interface=mobile", "acoes.csv"
get_fundamentus_info driver, "https://fundamentus.com.br/fii_resultado.php?interface=classic&interface=mobile", "fiis.csv"

driver.quit
