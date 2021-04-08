

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
var _marker2 = [];
function planificationOptimise() {
    map.addEventListener("tap", event => {
        if (!pm.Checked || pm.Checked == false) {
            var startPosition = map.screenToGeo(
                event.currentPointer.viewportX,
                event.currentPointer.viewportY
            );
            var markers = new H.map.Marker(startPosition);
            map.addObject(markers)
            _marker2.push(markers)
            console.log("start position :" + startPosition);
            _mapPoint.push(startPosition);

            if (_mapPoint.length > 1) {
                drawRoute(_mapPoint[_mapPoint.length - 2].lat, _mapPoint[_mapPoint.length - 2].lng, _mapPoint[_mapPoint.length - 1].lat, _mapPoint[_mapPoint.length - 1].lng);
            }
            event.preventDefault();
        }
    }, false)
}

var wayPoints = [];
var _routeLines = [];
var _lineStrings = [];
var _multiLinseStrings = []
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

                

                _routeLines.push(routeLine);

                _lineStrings.push(linestring);

                var multiLinseString = new H.geo.MultiLineString(_lineStrings)
                _multiLinseStrings.push(multiLinseString)

                // Set the map's viewport to make the whole route visible:
                map.setViewBounds(routeLine.getBounds());

                App.trajet.setValue(multiLinseString);
                console.log(multiLinseString);
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

var _markers = [];
var _straightPolylines = [];
var _po = [];
var _multiStraightLinseStrings = []
function planificationManuelle() {
    var po = map.addEventListener("tap", event => {
        if (pm.Checked == true) {
            position = map.screenToGeo(
                event.currentPointer.viewportX,
                event.currentPointer.viewportY
            );
            var markers = new H.map.Marker(position);
            map.addObject(markers)
            console.log(position);
            _markers.push(markers);

            if (_markers.length > 1) {
                straightLineString = new H.geo.LineString();
                straightLineString.pushPoint(_markers[_markers.length - 2].getPosition());
                straightLineString.pushPoint(_markers[_markers.length - 1].getPosition());
                straightPolyline = new H.map.Polyline(
                    straightLineString, { style: { lineWidth: 5 } }
                );

                map.addObjects([straightPolyline]);
                    
                _straightPolylines.push(straightLineString)
                
                var multiStraightLinseStrings = new H.geo.MultiLineString(_straightPolylines)
                _multiLinseStrings.push(multiStraightLinseStrings)
                App.trajet.setValue(multiStraightLinseStrings);
                console.log(multiStraightLinseStrings)
            }
            event.preventDefault();
         }
     }, false)
    _po.push(po)
}

planificationOptimise()

function testCheckBox() {
    if (!pm.Checked) {
        pm.Checked = false
        Ext.Msg.confirm(
            'Planification optimisee',
            'Voulez-vous changer le mode de planification ?',
            function (btn) {
                if (btn == 'yes') {
                    map.removeObjects(_routeLines);
                    map.removeObjects(_marker2);
                    _mapPoint = [];
                    _marker2 = [];
                    _routeLines = [];
                    wayPoints = [];
                    App.trajet.setValue();
                    planificationManuelle()
                }
            }
        );
        if (pm.Checked == false) {
            pm.Checked = true
        }
    }

    else {
        pm.Checked = true
        Ext.Msg.confirm(
            'Planification manuelle',
            'Voulez-vous changer le mode de planification ?',
            function (btn) {
                if (btn == 'yes') {
                    map.removeObjects(_straightPolylines);
                    map.removeObjects(_markers);
                    _markers.splice(0, _markers.length);
                    _straightPolylines.splice(0, _straightPolylines.length);
                    _po.splice(0, _po.length);
                    planificationOptimise()
                }
            }
        );
        if (pm.Checked == true) {
            pm.Checked = false
        }
    }
}

var _datas = []
function getTrajetFromDb() {
    ////if (Ext.isEmpty(trajet.getValue())) {
    // isDirty()
    ////    console.log("empty")
    ////}
    
    var data = App.trajet.getValue()
    var geoPoint = H.util.wkt.toGeometry(data)
    var polyline = new H.map.Polyline(
        geoPoint,
        { style: { strokeColor: 'blue', lineWidth: 10 } },
    );
    map.addObject(polyline);
    map.setViewBounds(polyline.getBounds());
    _datas.push(polyline)
    //console.log(_datas.length)

    if (_datas.length > 1) {
        map.removeObject(_datas[_datas.length - 2]);
        console.log(_datas.length)
    }
    
    //map.removeObject(polyline);
}

function resetMap() {
    if (App.trajet.getValue() == "") {
        map.removeObjects(map.getObjects())
        _mapPoint = [];
        _marker2 = [];
        _routeLines = [];
        wayPoints = [];
        _multiLinseStrings = []
        _lineStrings = [];
    }
}