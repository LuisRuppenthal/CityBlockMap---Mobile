import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, tap } from 'rxjs';
import { Block } from '../models/block.model';
import { environment } from '../../../environments/environment';

@Injectable({
  providedIn: 'root'
})

export class BlockService {
  private http = inject(HttpClient);
  private apiUrl = `${environment.apiUrl}/blocks`;

  getAll(): Observable<Block[]> {
  return this.http.get<Block[]>(this.apiUrl)
  //.pipe(tap(response => console.log('Resposta do backend:', response)));
}

  getById(id: number): Observable<Block> {
    return this.http.get<Block>(`${this.apiUrl}/${id}`);
  }
}