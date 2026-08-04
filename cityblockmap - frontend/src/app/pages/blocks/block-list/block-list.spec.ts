import { ComponentFixture, TestBed } from '@angular/core/testing';

import { BlockList } from './block-list';

describe('BlockList', () => {
  let component: BlockList;
  let fixture: ComponentFixture<BlockList>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [BlockList],
    }).compileComponents();

    fixture = TestBed.createComponent(BlockList);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
