import { ChangeDetectorRef, Component, inject, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { AuthService } from '../../core/services/authService';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './dashboard.html',
  styleUrl: './dashboard.css'
})
export class Dashboard implements OnInit {
  private cdr = inject(ChangeDetectorRef)
  private router = inject(Router);
  private http = inject(HttpClient);
  private authService = inject(AuthService);

  blockCount = 0;
  neighborhoodCount = 0;
  loadingBlocks = false;
  loadingNeighborhoods = false;

  ngOnInit(): void {
    this.loadCounts();
  }

  loadCounts(): void {
    this.loadingBlocks = true;
    this.http.get<any[]>('http://127.0.0.1:8080/blocks').subscribe({
      next: (data) => {
        this.blockCount = data.length;
        this.loadingBlocks = false;
        this.cdr.detectChanges();
      },
      error: () => {
        this.loadingBlocks = false;
      }
    });

    this.loadingNeighborhoods = true;
    this.http.get<any[]>('http://127.0.0.1:8080/neighborhoods/get').subscribe({
      next: (data) => {
        this.neighborhoodCount = data.length;
        this.loadingNeighborhoods = false;
        this.cdr.detectChanges();
      },
      error: () => {
        this.loadingNeighborhoods = false;
      }
    });
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

  goTo(path: string): void {
    this.router.navigate([path]);
  }
}