import { DialogRef } from '@angular/cdk/dialog';
import { Component, inject, AfterViewInit, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import * as L from 'leaflet';

const iconDefault = L.icon({
  iconUrl: 'marker-icon.png',
  shadowUrl: 'marker-shadow.png',
  iconRetinaUrl: 'marker-icon-2x.png',
  iconSize: [25, 41],
  iconAnchor: [12, 41],
  popupAnchor: [1, -34],
  shadowSize: [41, 41]
});
L.Marker.prototype.options.icon = iconDefault;

@Component({
  selector: 'app-map-picker-modal',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './map-picker-modal.html',
  styleUrl: './map-picker-modal.css',
})
export class MapPickerModal implements AfterViewInit {
  private dialogRef = inject(DialogRef);
  private cdr = inject(ChangeDetectorRef);

  selectedLat: number | null = null;
  selectedLng: number | null = null;
  private map?: L.Map;
  private marker?: L.Marker;

  ngAfterViewInit(): void {
    setTimeout(() => this.initMap(), 100);
  }

  private initMap(): void {
    this.map = L.map('map-picker').setView([-15.7801, -47.9292], 5); // Centro do Brasil

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; OpenStreetMap contributors'
    }).addTo(this.map);

    this.map.on('click', (e: L.LeafletMouseEvent) => {
      //console.log('Clique no mapa:', e.latlng);
      this.selectedLat = parseFloat(e.latlng.lat.toFixed(4));
      this.selectedLng = parseFloat(e.latlng.lng.toFixed(4));
      //console.log('Coordenadas:', this.selectedLat, this.selectedLng);

      if (this.marker) {
        this.map!.removeLayer(this.marker);
      }

      this.marker = L.marker([this.selectedLat, this.selectedLng])
        .addTo(this.map!)
        .bindPopup(`Lat: ${this.selectedLat}, Lng: ${this.selectedLng}`)
        .openPopup();

      this.cdr.detectChanges();
    });
  }

  protected closeMapPickerModal(): void {
    this.dialogRef.close();
  }

  protected getCoordinates(): void {
    if (this.selectedLat !== null && this.selectedLng !== null) {
      this.dialogRef.close({
        latitude: this.selectedLat,
        longitude: this.selectedLng
      });
    }
  }
}