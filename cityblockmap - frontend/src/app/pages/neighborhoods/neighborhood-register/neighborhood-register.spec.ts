import { ComponentFixture, TestBed } from '@angular/core/testing';

import { NeighborhoodRegister } from './neighborhood-register';

describe('NeighborhoodRegister', () => {
  let component: NeighborhoodRegister;
  let fixture: ComponentFixture<NeighborhoodRegister>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [NeighborhoodRegister],
    }).compileComponents();

    fixture = TestBed.createComponent(NeighborhoodRegister);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
