import { Dialog } from '@angular/cdk/dialog';
import { HttpClient } from '@angular/common/http';
import { ChangeDetectorRef, Component, inject } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { MapPickerModal } from '../../../modals/map-picker-modal/map-picker-modal';

interface Neighborhood {
  id: number;
  name: string;
}

@Component({
  selector: 'app-block-register',
  imports: [FormsModule],
  templateUrl: './block-register.html',
  styleUrl: './block-register.css',
})
export class BlockRegister {
  private http = inject(HttpClient);
  private router = inject(Router);
  private dialog = inject(Dialog);
  private cdr = inject(ChangeDetectorRef);

  form: {
    number: string;
    latitude: string | null;
    longitude: string | null;
    neighborhoodId: string;
  } = {
    number: '',
    latitude: '',
    longitude: '',
    neighborhoodId: ''
  };

  neighborhoods: Neighborhood[] = [];
  loadingNeighborhoods = false;
  loading = false;
  errorMessage = '';
  successMessage = '';

  ngOnInit(): void {
    this.loadNeighborhoods();
  }

  goBack(): void {
    this.router.navigate(['/blocks']);
  }

  loadNeighborhoods(): void {
    this.loadingNeighborhoods = true;
    this.http.get<Neighborhood[]>('http://127.0.0.1:8080/neighborhoods/get').subscribe({
      next: (data) => {
        this.neighborhoods = data;
        this.loadingNeighborhoods = false;
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
        this.form.latitude = String(result.latitude);
        this.form.longitude = String(result.longitude);
        this.cdr.detectChanges();
      }
    });
  }

  register(): void {
    if (!this.form.number || !this.form.latitude || !this.form.longitude || !this.form.neighborhoodId) {
      this.errorMessage = 'Preencha todos os campos obrigatórios.';
      return;
    }

    const lat = parseFloat(this.form.latitude);
    const lng = parseFloat(this.form.longitude);

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

    this.http.post('http://127.0.0.1:8080/blocks/create', payload).subscribe({
      next: () => {
        this.successMessage = 'Quadra cadastrada com sucesso!';
        this.loading = false;
        this.form = { number: '', latitude: null, longitude: null, neighborhoodId: '' };
        setTimeout(() => this.router.navigate(['/blocks']), 1500);
      },
      error: (err) => {
        this.loading = false;
        if (err.status === 400) {
          this.errorMessage = 'Dados inválidos. Verifique os campos.';
        } else {
          this.errorMessage = 'Erro ao cadastrar. Tente novamente.';
        }
      }
    });
  }
}