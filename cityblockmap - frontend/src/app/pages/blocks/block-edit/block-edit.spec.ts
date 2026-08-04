import { ComponentFixture, TestBed } from '@angular/core/testing';

import { BlockEdit } from './block-edit';

describe('BlockEdit', () => {
  let component: BlockEdit;
  let fixture: ComponentFixture<BlockEdit>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [BlockEdit],
    }).compileComponents();

    fixture = TestBed.createComponent(BlockEdit);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
