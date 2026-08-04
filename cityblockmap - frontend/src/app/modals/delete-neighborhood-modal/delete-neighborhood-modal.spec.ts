import { ComponentFixture, TestBed } from '@angular/core/testing';

import { DeleteNeighborhoodModal } from './delete-neighborhood-modal';

describe('DeleteNeighborhoodModal', () => {
  let component: DeleteNeighborhoodModal;
  let fixture: ComponentFixture<DeleteNeighborhoodModal>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [DeleteNeighborhoodModal],
    }).compileComponents();

    fixture = TestBed.createComponent(DeleteNeighborhoodModal);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
