import { ComponentFixture, TestBed } from '@angular/core/testing';

import { NeighborhoodList } from './neighborhood-list';

describe('NeighborhoodList', () => {
  let component: NeighborhoodList;
  let fixture: ComponentFixture<NeighborhoodList>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [NeighborhoodList],
    }).compileComponents();

    fixture = TestBed.createComponent(NeighborhoodList);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
