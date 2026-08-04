import { ComponentFixture, TestBed } from '@angular/core/testing';

import { NeighborhoodEdit } from './neighborhood-edit';

describe('NeighborhoodEdit', () => {
  let component: NeighborhoodEdit;
  let fixture: ComponentFixture<NeighborhoodEdit>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [NeighborhoodEdit],
    }).compileComponents();

    fixture = TestBed.createComponent(NeighborhoodEdit);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
