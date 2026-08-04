import { Neighborhood } from "./neighborhood.model";

export interface Block {
    id: number;
    number: string;
    latitude: number;
    longitude: number;
    neighborhood: Neighborhood;
}