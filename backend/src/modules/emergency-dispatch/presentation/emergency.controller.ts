import { Controller, Post, Body, Get, Query } from '@nestjs/common';
import { EmergencyUseCase, CreateEmergencyDto } from '../application/emergency.usecase';

@Controller('emergency')
export class EmergencyController {
  constructor(private readonly emergencyUseCase: EmergencyUseCase) {}

  @Post('request')
  async requestEmergency(@Body() dto: CreateEmergencyDto) {
    const result = await this.emergencyUseCase.createEmergencyRequest(dto);
    return {
      success: true,
      message: 'Emergency request created. Finding nearby helpers...',
      data: result,
    };
  }

  @Get('nearby')
  async getNearbyEmergencies(
    @Query('lat') lat: number,
    @Query('lng') lng: number,
    @Query('radius') radius: number = 10,
  ) {
    const emergencies = await this.emergencyUseCase.getUnassignedEmergencies(Number(lat), Number(lng), Number(radius));
    return {
      success: true,
      data: emergencies,
    };
  }
}
