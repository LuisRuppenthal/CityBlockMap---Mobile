import { Component, inject } from '@angular/core';
import { Router } from '@angular/router';
import { AuthService } from '../../core/services/authService';

@Component({
  selector: 'app-not-found',
  standalone: true,
  imports: [],
  templateUrl: './not-found.html',
  styleUrl: './not-found.css',
})
export class NotFound {
  private router = inject(Router);
  private authService = inject(AuthService);

  goBack(): void {
    if (this.authService.isAuthenticated()) {
      this.router.navigate(['/blocks']);
    } else {
      this.router.navigate(['/login']);
    }
  }
}
