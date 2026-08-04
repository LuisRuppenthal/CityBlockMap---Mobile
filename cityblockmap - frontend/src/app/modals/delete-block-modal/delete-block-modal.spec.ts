import { ComponentFixture, TestBed } from '@angular/core/testing';

import { DeleteBlockModal } from './delete-block-modal';

describe('DeleteModal', () => {
  let component: DeleteBlockModal;
  let fixture: ComponentFixture<DeleteBlockModal>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [DeleteBlockModal],
    }).compileComponents();

    fixture = TestBed.createComponent(DeleteBlockModal);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
