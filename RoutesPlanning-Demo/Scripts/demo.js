// Initialize the platform object:
var platform = new H.service.Platform({
    app_id: '11fwv4sG4XUzAX2Yb1nG',
    app_code: 'CXTAnyOfA2MdsvzCmDDh-g',
});

// Retrieve the target element for the map:
var targetElement = document.getElementById('mapContainer');

// Get the default map types from the platform object:
pixelRatio = window.devicePixelRatio || 1;
var defaultLayers = platform.createDefaultLayers({
    tileSize: pixelRatio === 1 ? 256 : 512, lg: 'FRE',
    ppi: pixelRatio === 1 ? undefined : 320
});

// Instantiate the map:
var map = new H.Map(
    document.getElementById('mapContainer'),
    defaultLayers.normal.map,
    {
        zoom: 14,
        center: { lat: 33.599724867110986, lng: -7.614547729492244 }
    }
);

mapEvent = new H.mapevents.MapEvents(map);
behavior = new H.mapevents.Behavior(mapEvent);
var ui = H.ui.UI.createDefault(map, defaultLayers, 'fr-FR');

var _mapPoint = [];
function planificationOptimise() {
    map.addEventListener("dbltap", event => {
        var startPosition = map.screenToGeo(
            event.currentPointer.viewportX,
            event.currentPointer.viewportY
        );
        var markers = new H.map.Marker(startPosition);
        map.addObject(markers)
        console.log("start position :" + startPosition);
        _mapPoint.push(startPosition);
        
        if (_mapPoint.length > 1) {
            drawRoute(_mapPoint[_mapPoint.length - 2].lat, _mapPoint[_mapPoint.length - 2].lng, _mapPoint[_mapPoint.length - 1].lat, _mapPoint[_mapPoint.length - 1].lng); 
        }
        event.preventDefault();
    }, false)
}

var wayPoints = [];
function drawRoute(startPosition1, endPosition1, startPosition2, endPosition2) {
    // Create the parameters for the routing request:
    var routingParameters = {
        // The routing mode:
        'mode': 'fastest;car;traffic:enabled',

        // The start point of the route:
        'waypoint0': 'geo!' + startPosition1 + ',' + endPosition1,

        // The end point of the route :
        'waypoint1': 'geo!' + startPosition2 + ',' + endPosition2,

        // To retrieve the shape of the route we choose the route
        // representation mode 'display'
        'representation': 'display'
    };
    wayPoints.push(routingParameters);
    if (wayPoints.length > -1) {
        console.log(wayPoints);
        // Define a callback function to process the routing response:
        var onResult = function (result) {
            var route,
                routeShape,
                linestring;
            if (result.response.route) {
                // Pick the first route from the response:
                route = result.response.route[0];

                // Pick the route's shape:
                routeShape = route.shape;

                // Create a linestring to use as a point source for the route line
                linestring = new H.geo.LineString();

                // Push all the points in the shape into the linestring:
                routeShape.forEach(function (point) {
                    var parts = point.split(',');
                    linestring.pushLatLngAlt(parts[0], parts[1]);
                });

                // Retrieve the mapped positions of the requested waypoints:
                startPoint = route.waypoint[0].mappedPosition;
                endPoint = route.waypoint[1].mappedPosition;

                // Create a polyline to display the route:
                var routeLine = new H.map.Polyline(linestring, {
                    style: { strokeColor: 'blue', lineWidth: 10 }
                });

                // Add the route polyline and the two markers to the map:
                map.addObjects([routeLine]);

                // Set the map's viewport to make the whole route visible:
                map.setViewBounds(routeLine.getBounds());
            }
        };

        // Get an instance of the routing service:
        var router = platform.getRoutingService();

        // Call calculateRoute() with the routing parameters,
        // the callback and an error callback function (called if a communication error occurs):
        router.calculateRoute(routingParameters, onResult,
            function (error) {
                alert(error.message);
            }
        );
    }
}


function planificationManuelle() {
    var _markers = [];
    map.addEventListener("dbltap", event => {
        var position = map.screenToGeo(
            event.currentPointer.viewportX,
            event.currentPointer.viewportY
        );
        var markers = new H.map.Marker(position);
        map.addObject(markers)
        console.log(position);
        _markers.push(markers);

        if (_markers.length > 1) {
            const straightLineString = new H.geo.LineString();
            straightLineString.pushPoint(_markers[_markers.length - 2].getPosition());
            straightLineString.pushPoint(_markers[_markers.length - 1].getPosition());
            const straightPolyline = new H.map.Polyline(
                straightLineString, { style: { lineWidth: 5 } }
            );
            map.addObjects([straightPolyline]);
        }
        event.preventDefault();
    }, false)
}


function testCheckBox() {
    /*var test = App.pm.getValue();
    console.log(test)
    test.checked
    if (test) {
        planificationOptimise();
    }
    else {
        planificationManuelle();
    }*/
    console.log("good")
}





