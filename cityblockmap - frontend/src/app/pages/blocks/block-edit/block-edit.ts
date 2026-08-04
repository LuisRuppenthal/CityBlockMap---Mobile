import { ChangeDetectorRef, Component, inject, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { MapPickerModal } from '../../../modals/map-picker-modal/map-picker-modal';
import { Dialog } from '@angular/cdk/dialog';

interface Neighborhood {
  id: number;
  name: string;
}

@Component({
  selector: 'app-block-edit',
  standalone: true,
  imports: [FormsModule],
  templateUrl: './block-edit.html',
  styleUrl: './block-edit.css'
})
export class BlockEdit implements OnInit {
  private cdr = inject(ChangeDetectorRef)
  private http = inject(HttpClient);
  private router = inject(Router);
  private route = inject(ActivatedRoute);
  private dialog = inject(Dialog)

  blockId!: number;

  form: {
    number: string;
    latitude: number | null;
    longitude: number | null;
    neighborhoodId: string;
  } = {
    number: '',
    latitude: null,
    longitude: null,
    neighborhoodId: ''
  };

  neighborhoods: Neighborhood[] = [];
  loadingBlock = false;
  loadingNeighborhoods = false;
  loading = false;
  errorMessage = '';
  successMessage = '';

  ngOnInit(): void {
    this.blockId = Number(this.route.snapshot.paramMap.get('id'));
    this.loadNeighborhoods();
    this.loadBlock();
  }

  loadNeighborhoods(): void {
    this.loadingNeighborhoods = true;
    this.http.get<Neighborhood[]>('http://127.0.0.1:8080/neighborhoods/get').subscribe({
      next: (data) => {
        this.neighborhoods = data;
        this.loadingNeighborhoods = false;
        this.cdr.detectChanges();
      },
      error: () => {
        this.loadingNeighborhoods = false;
      }
    });
  }

  protected openMapPickerModal(): void {
    const ref = this.dialog.open(MapPickerModal, {
      disableClose: true,
      hasBackdrop: true
    });
 
    ref.closed.subscribe((result: any) => {
      if (result) {
        this.form.latitude = (result.latitude);
        this.form.longitude = (result.longitude);
        this.cdr.detectChanges();
      }
    });
  }

  loadBlock(): void {
    this.loadingBlock = true;
    this.http.get<any>(`http://127.0.0.1:8080/blocks/get/${this.blockId}`).subscribe({
      next: (block) => {
        this.form = {
          number: block.number,
          latitude: block.latitude,
          longitude: block.longitude,
          neighborhoodId: String(block.neighborhood.id)
        };
        this.loadingBlock = false;
        this.cdr.detectChanges(); 
      },
      error: () => {
        this.errorMessage = 'Erro ao carregar a quadra.';
        this.loadingBlock = false;
      }
    });
  }

  update(): void {
    if (!this.form.number || this.form.latitude === null || this.form.longitude === null || !this.form.neighborhoodId) {
      this.errorMessage = 'Preencha todos os campos obrigatórios.';
      return;
    }

    const lat = Number(this.form.latitude);
    const lng = Number(this.form.longitude);

    if (isNaN(lat) || lat < -90 || lat > 90) {
      this.errorMessage = 'Latitude inválida. Use valores entre -90 e 90.';
      return;
    }

    if (isNaN(lng) || lng < -180 || lng > 180) {
      this.errorMessage = 'Longitude inválida. Use valores entre -180 e 180.';
      return;
    }

    this.loading = true;
    this.errorMessage = '';
    this.successMessage = '';

    const selectedNeighborhood = this.neighborhoods.find(n => n.id === Number(this.form.neighborhoodId));

    const payload = {
      number: this.form.number,
      latitude: lat,
      longitude: lng,
      neighborhood: selectedNeighborhood
    };

    this.http.put(`http://127.0.0.1:8080/blocks/update/${this.blockId}`, payload).subscribe({
      next: () => {
        this.successMessage = 'Quadra atualizada com sucesso!';
        this.loading = false;
        setTimeout(() => this.router.navigate(['/blocks']), 1500);
      },
      error: (err) => {
        this.loading = false;
        if (err.status === 400) {
          this.errorMessage = 'Dados inválidos. Verifique os campos.';
        } else {
          this.errorMessage = 'Erro ao salvar. Tente novamente.';
        }
      }
    });
  }

  goBack(): void {
    this.router.navigate(['/blocks']);
  }
}