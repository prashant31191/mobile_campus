@RestResource(urlMapping='/BusStops/')
global with sharing class  mob_BusStops_Routes {

    @HttpGet
    global static List<BusRoutes> getBusRoutes(RestRequest req, RestResponse res) {
        List<BusRoutes> busRoutes = new List<BusRoutes>();
        String rootName = null;
        Map<String,List<BusStop>> busStopMap = new Map<String,List<BusStop>> (); 
        for(Bus_Stops_Routes__c busStopRoutes:[Select  Bus_Stop__r.Long__c, Bus_Stop__r.Lat__c,
                                               Bus_Stop__r.Name, Bus_Stop__r.Active__c, Bus_Stop__r.Id,
                                               Bus_Route__r.Name, Bus_Route__r.Route_Color__c, Bus_Route__r.Id
                                               From Bus_Stops_Routes__c order by Stop_Order__c ]){
            BusStop  stop = new BusStop();
            stop.stopName =  busStopRoutes.Bus_Stop__r.Name;
            stop.longitude = busStopRoutes.Bus_Stop__r.Long__c;
            stop.latitude =  busStopRoutes.Bus_Stop__r.Lat__c; 
            stop.active = busStopRoutes.Bus_Stop__r.Active__c;
            stop.color = busStopRoutes.Bus_Route__r.Route_Color__c;  
            BusRoutes routes = new BusRoutes();
            routes.stops = new List<BusStop>();
            if(busStopMap.containsKey(busStopRoutes.Bus_Route__r.Name)){
               busStopMap.get(busStopRoutes.Bus_Route__r.Name).add(stop);
            }else{
               routes.stops = new List<BusStop>();
               routes.stops.add(stop);
               busStopMap.put(busStopRoutes.Bus_Route__r.Name,routes.stops);    
            }
        }
        if(!busStopMap.isEmpty()){
            for(String key:busStopMap.keySet()){
              BusRoutes routes = new BusRoutes();
              routes.stops = new List<BusStop>();
              routes.routeName = key;
              routes.stops = busStopMap.get(key);
              busRoutes.add(routes);        
            }
        }
        return busRoutes;
    }
    
    global  class BusRoutes{
        public String routeName{get;set;}
        public List<BusStop> stops{get;set;}
    }
    
    public  class BusStop{
        public String stopName{get;set;}
        public double latitude{get;set;}
        public double longitude{get;set;}
        public boolean active{get;set;}
        public String color{get;set;}
    }
}