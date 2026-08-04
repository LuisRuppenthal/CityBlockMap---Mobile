
import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';

export const adminGuard: CanActivateFn = () => {
  const router = inject(Router);
  const token = localStorage.getItem('token');

  if (!token) return router.createUrlTree(['/login']);

  try {
    const payload = JSON.parse(atob(token.split('.')[1]));
    
    if (payload.role === 'ADMIN') return true;

  } catch {
    return router.createUrlTree(['/login']);
  }

  return router.createUrlTree(['/blocks']);
};
