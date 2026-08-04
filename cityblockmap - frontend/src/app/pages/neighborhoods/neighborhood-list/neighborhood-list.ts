import { ChangeDetectorRef, Component, inject } from '@angular/core';
import { NeighborhoodService } from '../../../core/services/neighborhood-service';
import { AuthService } from '../../../core/services/authService';
import { Router } from '@angular/router';
import { Dialog } from '@angular/cdk/dialog';
import { Neighborhood } from '../../../core/models/neighborhood.model';
import { DeleteNeighborhoodModal } from '../../../modals/delete-neighborhood-modal/delete-neighborhood-modal';

@Component({
  selector: 'app-neighborhood-list',
  imports: [],
  templateUrl: './neighborhood-list.html',
  styleUrl: './neighborhood-list.css',
})
export class NeighborhoodList {
  private authService = inject(AuthService);
  private neighborhoodService = inject(NeighborhoodService);
  private router = inject(Router);
  private cdr = inject(ChangeDetectorRef)
  private dialog = inject(Dialog);

  neighborhoods: Neighborhood[] = [];
  loading = false;
  errorMessage = '';

  ngOnInit(): void {
    this.loadNeighborhoods();
  }

  isAdmin(): boolean {
    const token = this.authService.getToken();
    if (!token) return false;
    try {
      const payload = JSON.parse(atob(token.split('.')[1]));
      return payload.role === 'ADMIN';
    } catch {
      return false;
    }
  }

  protected openDeleteModal(id: number) {
    const ref = this.dialog.open(DeleteNeighborhoodModal, { disableClose: true, data: { id } });

    ref.closed.subscribe(resultado => {
      if (resultado === 'confirmado') {
        this.loadNeighborhoods()
      }
      window.location.reload()
    });
  }

  goToNeighborhoodEdit(id: number): void {
    this.router.navigate(['/neighborhood-edit', id]);
  }

  loadNeighborhoods(): void {
    this.loading = true;

    this.neighborhoodService.getAll().subscribe({
      next: (response) => {
        this.neighborhoods = response;
        this.loading = false;
        this.cdr.detectChanges();
      },
      error: () => {
        this.errorMessage = 'Erro ao carregar as quadras.';
        this.loading = false;
        this.cdr.detectChanges();
      }
    });
  }

  openNeighborhood(id: number): void {
    console.log("Não implementado")
    //this.router.navigate(['/blocks', id])
  }
}

