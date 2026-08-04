import { ComponentFixture, TestBed } from '@angular/core/testing';

import { BlockRegister } from './block-register';

describe('BlockRegister', () => {
  let component: BlockRegister;
  let fixture: ComponentFixture<BlockRegister>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [BlockRegister],
    }).compileComponents();

    fixture = TestBed.createComponent(BlockRegister);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
