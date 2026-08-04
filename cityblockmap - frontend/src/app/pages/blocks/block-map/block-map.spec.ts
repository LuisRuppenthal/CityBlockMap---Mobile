import { ComponentFixture, TestBed } from '@angular/core/testing';

import { BlockMap } from './block-map';

describe('BlockMap', () => {
  let component: BlockMap;
  let fixture: ComponentFixture<BlockMap>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [BlockMap],
    }).compileComponents();

    fixture = TestBed.createComponent(BlockMap);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
