import { ComponentFixture, TestBed } from '@angular/core/testing';

import { MapPickerModal } from './map-picker-modal';

describe('MapPickerModal', () => {
  let component: MapPickerModal;
  let fixture: ComponentFixture<MapPickerModal>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [MapPickerModal],
    }).compileComponents();

    fixture = TestBed.createComponent(MapPickerModal);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
 