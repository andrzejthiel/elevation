# Copyright Google Inc. 2010 All Rights Reserved
require 'open-uri'
require 'json'
require 'active_support/core_ext'
require 'net/http'

ELEVATION_BASE_URL = 'http://maps.google.com/maps/api/elevation/json'
CHART_BASE_URL = 'http://chart.apis.google.com/chart'

def getChart(chartData, chartDataScaling="1300,2800", chartType="lc",chartLabel="Elevation in Meters                                         Profil trasy do pokonania",chartSize="700x400", chartColor="black", chart_args={})
    
    chart_args.merge!({
	    chtt: "Z Rys na Giewont",
        cht: chartType,
        chs: chartSize,
        chl: chartLabel,
		chxp: "0,20",
        chco: chartColor,
		chls: "2",
        chds: chartDataScaling,
        chxt: 'x,y',
        chxr: '1,1500,3000',
		chm: "B,76A4FB,0,0,0"
    })


    dataString = 't:' + chartData.join(',')
    chart_args['chd'] = dataString
   
    chartUrl = CHART_BASE_URL + '?' + chart_args.to_query


    puts "Elevation Chart URL:"
    puts chartUrl
end

def getElevation(path="49.1848,20.0869|49.2514,19.9337",samples="100",sensor="false", elvtn_args={})

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
        

      startStr = "49.1848,20.0869"
 
      endStr = "49.2514,19.9337"

    pathStr = startStr + "|" + endStr

    getElevation(pathStr)