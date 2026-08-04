import { HttpClient } from '@angular/common/http';
import { Component, inject } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';

@Component({
  selector: 'app-neighborhood-register',
  imports: [FormsModule],
  templateUrl: './neighborhood-register.html',
  styleUrl: './neighborhood-register.css',
})
export class NeighborhoodRegister {
  private http = inject(HttpClient);
  private router = inject(Router);

  form: {
    name: string;
  } = {
      name: ''
    };


  loading = false;
  errorMessage = '';
  successMessage = '';

  goBack(): void {
    this.router.navigate(['/neighborhoods']);
  }

  register(): void {
    if (!this.form.name) {
      this.errorMessage = 'Preencha todos os campos obrigatórios.';
      return;
    };

    this.loading = true;
    this.errorMessage = '';
    this.successMessage = '';

    const payload = {
      name: this.form.name
    };

    this.http.post('http://127.0.0.1:8080/neighborhoods/create', payload).subscribe({
      next: () => {
        this.successMessage = 'Bairro cadastrado com sucesso!';
        this.loading = false;
        this.form = { name: ''};
        setTimeout(() => this.router.navigate(['/neighborhoods']), 1500);
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

