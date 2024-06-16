// Automatic setup generated below:

// import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="map"
// export default class extends Controller {
//   connect() {
//   }
// }


import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'

export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v10"
    })
    this.#addMarkersToMap()
    // this.#fitMapToMarkers() --> Not sure I want the map to only show the markers area, commented for now 16-06-24

    this.map.addControl(new MapboxGeocoder ({
      accessToken: mapboxgl.accessToken,
      mapboxgl: mapboxgl }));
  }

  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)
      new mapboxgl.Marker()
        .setLngLat([ marker.lng, marker.lat ])
        .setPopup(popup)
        .addTo(this.map)

    })
  }

  // #fitMapToMarkers() {  --> See line 29
  //   const bounds = new mapboxgl.LngLatBounds()
  //   this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
  //   this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
  // }

}
