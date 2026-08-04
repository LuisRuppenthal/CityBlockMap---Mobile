import { Component, inject, signal } from '@angular/core';
import { RouterOutlet, Router, NavigationEnd } from '@angular/router';
import { CommonModule } from '@angular/common';
import { AuthService } from './core/services/authService';
import { filter } from 'rxjs';
import { SessionExpiredService } from './core/services/session-expired-service';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, CommonModule],
  templateUrl: './app.html',
  styleUrl: './app.css'
})
export class App {
  protected readonly title = signal('cityblockmap-frontend');
  isMenuOpen = false;

  private authService = inject(AuthService);
  private router = inject(Router);
  readonly sessionExpiredService = inject(SessionExpiredService);

  //Trecho necessário para esconder o header quando se está na pagina de Login
  currentRoute = '';

  constructor() {
    this.router.events.pipe(
      filter(event => event instanceof NavigationEnd)
    ).subscribe((event: any) => {
      this.currentRoute = event.urlAfterRedirects;
    });
  }

  isAuthenticated(): boolean {
    return this.authService.isAuthenticated() && this.currentRoute !== '/login';
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

  getLogin(): string {
    const token = this.authService.getToken();
    if (!token) return '';
    try {
      const payload = JSON.parse(atob(token.split('.')[1]));
      return payload.sub ?? '';
    } catch {
      return '';
    }
  }

  goToDashboard(): void {
    this.router.navigate(['/dashboard']);
  }

  goToRegister(): void {
    this.router.navigate(['/register']);
  }

  goToNeighborhoodRegister(): void {
    this.router.navigate(['/neighborhood-register']);
  }

  goToBlockRegister(): void {
    this.router.navigate(['/block-register']);
  }

  goToSettings(): void {
    this.isMenuOpen = false;
    console.log("Não implementado")
    //this.router.navigate(['/settings']);
  }

  logout(): void {
    //this.isMenuOpen = false;
    this.authService.logout();
    this.router.navigate(['/login']);
  }

  //Dropdown
  toggleUserMenu(): void {
    //console.log("toggleUserMenu utilizado")
    this.isMenuOpen = !this.isMenuOpen;
  }
}