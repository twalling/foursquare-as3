Introduction
============

The foursquare API supports responses in either JSON or XML. The response format can be set on the service class and by default it's set to JSON. The service needs a base URL but its defaulted to http://api.foursquare.com/v1.

Create instance of service
==========================

    import com.timwalling.foursquare.FoursquareRequestFormat;
    import com.timwalling.foursquare.FoursquareOperation;
    import com.timwalling.foursquare.FoursquareService;
    
    var service:FoursquareService = new FoursquareService();
    service.timeout = 20; // optional timeout, default is no timeout
    service.format = FoursquareRequestFormat.XML; // optionally if you want XML instead of JSON

Create operation for the API call
=================================

    var operation:FoursquareOperation = service.findVenues(LAT, LONG);
    operation.addEventListener(Event.COMPLETE, handleComplete);
    operation.addEventListener(ErrorEvent.ERROR, handleError);
    operation.execute();
    
    private function handleComplete(event:Event):void
    {
        trace(FoursquareOperation(event.target).data);
    }
                
    private function handleError(event:ErrorEvent):void
    {
        trace(event.text);
    }

Accessing response data
=======================
Since JSON or XML can be returned you can access the data in different ways. If you use the default which is JSON then another actionscript library is required to decode the JSON string. as3corelib has some JSON classes and the library can be found here: http://code.google.com/p/as3corelib/.

JSON example:

    import com.adobe.serialization.json.JSON;
    
    var response:Object = JSON.decode(operation.data as String);

If XML is preferred, no 3rd party libraries are needed and the data can be accessed directly as XML.

XML example:

    var response:XML = operation.data as XML;