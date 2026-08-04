import { Component, inject, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { HttpClient } from '@angular/common/http';

interface Neighborhood {
  id: number;
  name: string;
  blocks?: any[];
}

@Component({
  selector: 'app-register',
  standalone: true,
  imports: [FormsModule],
  templateUrl: './register.html',
  styleUrl: './register.css'
})
export class Register implements OnInit {
  private http = inject(HttpClient);
  private router = inject(Router);
 
  form = {
    login: '',
    password: '',
    role: ''
  };

  neighborhoods: Neighborhood[] = [];
  //selectedNeighborhoods: Neighborhood[] = [];
  loadingNeighborhoods = false;
  loading = false;
  errorMessage = '';
  successMessage = '';

  ngOnInit(): void {
    this.loadNeighborhoods();
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

  /*toggleNeighborhood(n: Neighborhood): void {
    const index = this.selectedNeighborhoods.findIndex(s => s.id === n.id);
    if (index >= 0) {
      this.selectedNeighborhoods.splice(index, 1);
    } else {
      this.selectedNeighborhoods.push({ id: n.id, name: n.name });
    }
  }*/

  /*isSelected(id: number): boolean {
    return this.selectedNeighborhoods.some(n => n.id === id);
  }*/

  register(): void {
    if (!this.form.login || !this.form.password || !this.form.role) {
      this.errorMessage = 'Preencha todos os campos obrigatórios.';
      return;
    }

    this.loading = true;
    this.errorMessage = '';
    this.successMessage = '';

    const payload = {
      ...this.form,
      //neighborhood: this.selectedNeighborhoods
    };

    this.http.post('http://127.0.0.1:8080/users/create', payload).subscribe({
      next: () => {
        this.successMessage = 'Usuário cadastrado com sucesso!';
        this.loading = false;
        this.form = { login: '', password: '', role: '' };
        //this.selectedNeighborhoods = [];
        setTimeout(() => this.router.navigate(['/dashboard']), 1500);
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

  goBack(): void {
    this.router.navigate(['/dashboard']);
  }
}