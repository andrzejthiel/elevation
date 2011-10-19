require 'open-uri'
require 'json'
require 'active_support/core_ext'
require 'net/http'

ELEVATION_BASE_URL = 'http://maps.google.com/maps/api/elevation/json'
CHART_BASE_URL = 'http://chart.apis.google.com/chart'

def getChart(chartData, chartDataScaling="-500,5000", chartType="lc",chartLabel="Elevation in Meters                                         Profil trasy do pokonania",chartSize="700x400", chartColor="orange", chart_args={})
    
    chart_args.merge!({
        chtt: "Trasa z punktu A do punktu B",
        cht: chartType,
        chs: chartSize,
        chl: chartLabel,
		chxp: "0,20",
        chco: chartColor,
		chls: "2",
        chds: chartDataScaling,
        chxt: 'x,y',
        chxr: '1,-500,5000',
		chm: "B,76A4FB,0,0,0"
    })


    dataString = 't:' + chartData.join(',')
    chart_args['chd'] = dataString
   
    chartUrl = CHART_BASE_URL + '?' + chart_args.to_query

    puts
    puts "Elevation Chart URL:"
    puts
    puts chartUrl
end

def getElevation(path="36.578581,-118.291994|36.23998,-116.83171",samples="100",sensor="false", elvtn_args={})

    elvtn_args.merge!({
        path: path,
        samples: samples,
        sensor: sensor
    })
   
    url = ELEVATION_BASE_URL + '?' + elvtn_args.to_query

    resp = Net::HTTP.get_response(URI.parse(url))
    response = JSON.parse(resp.body)

    # Create a dictionary for each results[] object
    elevationArray = []
    for result in response['results']
      elevationArray << result["elevation"].round(0) # zaokraglamy bo jest za duzo miejsc po przecinku, przez co google marudzi, ze request jest za dlugi
    end
    
    # Create the chart passing the array of elevation data
    getChart(elevationArray)
end
        


    # Collect the Latitude/Longitude input string
    # from the user
    puts 'podaj wspolrzedne punktu A (poczatkowego) np. 36.00,-118.00 '
    startStr = gets.gsub(' ','').chomp
    if startStr.empty?
     puts "nie podales wspolrzednych punktu poczatkowego!"
    else
    puts "Podaj wspolrzedne punktu B(koncowego) np. 36.00,-116.00"
	
    endStr = gets.gsub(' ','').chomp
    if endStr.empty?
      "nie podales wspolrzednych punktu koncowego!"
    else
	 pathStr = startStr + "|" + endStr

    getElevation(pathStr)
	end
	end
   