import { HttpClient } from '@angular/common/http';
import { ChangeDetectorRef, Component, inject, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';

@Component({
  selector: 'app-neighborhood-edit',
  imports: [FormsModule],
  templateUrl: './neighborhood-edit.html',
  styleUrl: './neighborhood-edit.css',
})
export class NeighborhoodEdit implements OnInit {
  private cdr = inject(ChangeDetectorRef)
  private http = inject(HttpClient);
  private router = inject(Router);
  private route = inject(ActivatedRoute);

  neighborhoodId!: number;

  form: {
    name: string;
  } = {
      name: ''
    };

  loadingNeighborhoods = false;
  loading = false;
  errorMessage = '';
  successMessage = '';


  ngOnInit(): void {
    this.neighborhoodId = Number(this.route.snapshot.paramMap.get('id'));
    this.loadNeighborhoods();
  }

  loadNeighborhoods(): void {
    this.loadingNeighborhoods = true;
    this.http.get<any>(`http://127.0.0.1:8080/neighborhoods/get/${this.neighborhoodId}`).subscribe({
      next: (neighborhood) => {
        this.form = {
          name: neighborhood.name
        };
        this.loadingNeighborhoods = false;
        this.cdr.detectChanges(); 
      },
      error: () => {
        this.errorMessage = 'Erro ao carregar o bairro.';
        this.loadingNeighborhoods = false;
      }
    });
  }

  update(): void {
    if (!this.form.name) {
      this.errorMessage = 'Preencha todos os campos obrigatórios.';
      return;
    }

    this.loading = true;
    this.errorMessage = '';
    this.successMessage = '';

    const payload = {
      name: this.form.name
    };

    this.http.put(`http://127.0.0.1:8080/neighborhoods/update/${this.neighborhoodId}`, payload).subscribe({
      next: () => {
        this.successMessage = 'Bairro atualizado com sucesso!';
        this.loading = false;
        setTimeout(() => this.router.navigate(['/neighborhoods']), 1500);
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
    this.router.navigate(['/neighborhoods']);
  }

}
