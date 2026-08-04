import { Dialog, DIALOG_DATA, DialogRef } from '@angular/cdk/dialog';
import { HttpClient } from '@angular/common/http';
import { Component, inject } from '@angular/core';

@Component({
  selector: 'app-delete-block-modal',
  imports: [],
  templateUrl: './delete-block-modal.html',
  styleUrl: './delete-block-modal.css',
})
export class DeleteBlockModal {
  private dialogRef = inject(DialogRef);
  private http = inject(HttpClient);
  private data = inject(DIALOG_DATA);


  protected closeDeleteModal() {
    this.dialogRef?.close();
  };

  protected deleteModal() {
    this.http.delete(`http://127.0.0.1:8080/blocks/delete/${this.data.id}`).subscribe({
      next: () => this.dialogRef.close('confirmado'),
      error: () => this.dialogRef.close()
    });
  }
}