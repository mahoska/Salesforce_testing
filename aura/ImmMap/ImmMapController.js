({
	 jsLoaded: function(component, event, helper) {
      var map = L.map('map', {zoomControl: false, tap: false})
                  .setView([48.9, 31.9], 6);
      L.tileLayer(
       'https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',
       {
              attribution: 'Tiles © Esri'
       }).addTo(map);
      component.set("v.map", map);
  },
    
    immLoaded: function(component, event, helper) {
        // Add markers
        var map = component.get('v.map');
        var immovables = event.getParam('immovables');
        for (var i=0; i<immovables.length; i++) {
            var imm = immovables[i];
            var latLng = [imm.Location__Latitude__s, imm.Location__Longitude__s];
            L.marker(latLng, {immovables: imm}).addTo(map).on('click', function(event) {
                helper.navigateToDetailsView(event.target.options.immovables.Id);
            });
            
        }  
    },
    immSelected: function(component, event, helper) {
        // Center the map on the imm selected in the list
        var map = component.get('v.map');
        var imm = event.getParam("immovables");
        map.panTo([imm.Location__Latitude__s, imm.Location__Longitude__s]);
    }
})