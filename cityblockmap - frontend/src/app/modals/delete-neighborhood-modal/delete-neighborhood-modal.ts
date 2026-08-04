import { Dialog, DIALOG_DATA, DialogRef } from '@angular/cdk/dialog';
import { HttpClient } from '@angular/common/http';
import { Component, inject } from '@angular/core';

@Component({
  selector: 'app-delete-neighborhood-modal',
  imports: [],
  templateUrl: './delete-neighborhood-modal.html',
  styleUrl: './delete-neighborhood-modal.css',
})
export class DeleteNeighborhoodModal {
  private dialogRef = inject(DialogRef);
  private http = inject(HttpClient);
  private data = inject(DIALOG_DATA);


  protected closeDeleteModal() {
    this.dialogRef?.close();
  };

  protected deleteModal() {
    this.http.delete(`http://127.0.0.1:8080/neighborhoods/delete/${this.data.id}`).subscribe({
      next: () => this.dialogRef.close('confirmado'),
      error: () => this.dialogRef.close()
    });
  }
}
