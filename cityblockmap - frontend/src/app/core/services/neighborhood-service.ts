import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, tap } from 'rxjs';
import { Neighborhood } from '../models/neighborhood.model';
import { environment } from '../../../environments/environment';

@Injectable({
  providedIn: 'root',
})

export class NeighborhoodService {
  private http = inject(HttpClient);
  private apiUrl = `${environment.apiUrl}/neighborhoods`;

  getAll(): Observable<Neighborhood[]> {
    return this.http.get<Neighborhood[]>(this.apiUrl);
    //.pipe(tap(response => console.log('Resposta do backend:', response)));
  }

  getById(id: number): Observable<Neighborhood> {
    return this.http.get<Neighborhood>(`${this.apiUrl}/${id}`);
  }
}  