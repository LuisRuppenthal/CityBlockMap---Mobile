import { AfterViewInit, Component, inject, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute } from '@angular/router';
import * as L from 'leaflet';
import { Block } from '../../../core/models/block.model';
import { BlockService } from '../../../core/services/blockService';

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
  selector: 'app-block-map',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './block-map.html',
  styleUrl: './block-map.css'
})
export class BlockMap implements AfterViewInit {
  private route = inject(ActivatedRoute);
  private blockService = inject(BlockService);
  private cdr = inject(ChangeDetectorRef);

  block?: Block;
  errorMessage = '';
  private map?: L.Map;

  ngAfterViewInit(): void {
    const id = Number(this.route.snapshot.paramMap.get('id'));

    if (!id) {
      this.errorMessage = 'ID da quadra inválido.';
      return;
    }

    this.blockService.getById(id).subscribe({
      next: (response) => {
        this.block = response;
        this.cdr.detectChanges(); // Necessário para atualizar o DOM e evitar outro bug que estava ocorrendo

        
        if (this.map) {
          this.map.remove();
          this.map = undefined;
        }

        this.initMap(response.latitude, response.longitude, response.number);
      },
      error: () => {
        this.errorMessage = 'Erro ao carregar a quadra.';
        this.cdr.detectChanges();
      }
    });
  }

  private initMap(latitude: number, longitude: number, number: string): void {
    this.map = L.map('map').setView([latitude, longitude], 16);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; OpenStreetMap contributors'
    }).addTo(this.map);

    L.marker([latitude, longitude])
      .addTo(this.map)
      .bindPopup(number)
      .openPopup();
  }
} 