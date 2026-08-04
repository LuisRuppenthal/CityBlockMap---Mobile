import { ChangeDetectorRef, Component, inject, OnInit } from '@angular/core';
import { BlockService } from '../../../core/services/blockService';
import { Router } from '@angular/router';
import { Block } from '../../../core/models/block.model';
import { CommonModule } from '@angular/common';
import { AuthService } from '../../../core/services/authService';
import { Dialog, DialogRef } from '@angular/cdk/dialog';
import { DeleteBlockModal } from '../../../modals/delete-block-modal/delete-block-modal';

@Component({
  selector: 'app-block-list',
  imports: [CommonModule],
  templateUrl: './block-list.html',
  styleUrl: './block-list.css',
})
export class BlockList implements OnInit {

  private authService = inject(AuthService);
  private blockService = inject(BlockService);
  private router = inject(Router);
  private cdr = inject(ChangeDetectorRef)
  private dialog = inject(Dialog);

  blocks: Block[] = [];
  loading = false;
  errorMessage = '';

  ngOnInit(): void {
    this.loadBlocks();
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

  protected openDeleteModal(id:number) {
    const ref = this.dialog.open(DeleteBlockModal, { disableClose: true, data: {id}});

    ref.closed.subscribe(resultado => {
      if (resultado ==='confirmado') {
        this.loadBlocks()
      }
      window.location.reload()
    });
  }

  goToBlockEdit(id: number): void {
    this.router.navigate(['/block-edit', id]);
  }

  loadBlocks(): void {
    this.loading = true;

    this.blockService.getAll().subscribe({
      next: (response) => {
        this.blocks = response;
        this.loading = false;
        this.cdr.detectChanges();
      },
      error: () => {
        this.errorMessage = 'Erro ao carregar as quadras.';
        this.loading = false;
        this.cdr.detectChanges();
      }
    });
  }

  openBlock(id: number): void {
    this.router.navigate(['/blocks', id])
  }
}