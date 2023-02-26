-- CreateTable
CREATE TABLE `organization` (
    `id` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `authId` VARCHAR(191) NULL,
    `logoUrl` VARCHAR(191) NULL,
    `showDemographicForm` BOOLEAN NULL,
    `minGroupSize` INTEGER NULL,
    `minTeamSize` INTEGER NULL,
    `metadata` JSON NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,
    `deletedAt` DATETIME(3) NULL,

    UNIQUE INDEX `organization_name_key`(`name`),
    UNIQUE INDEX `organization_authId_key`(`authId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `user` (
    `id` VARCHAR(191) NOT NULL,
    `organizationId` VARCHAR(191) NOT NULL,
    `authId` VARCHAR(191) NOT NULL,
    `invitedAt` DATETIME(3) NULL,
    `metadata` JSON NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,
    `deletedAt` DATETIME(3) NULL,

    UNIQUE INDEX `user_authId_key`(`authId`),
    INDEX `user_organizationId_fkey`(`organizationId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `survey` (
    `id` VARCHAR(191) NOT NULL,
    `organizationId` VARCHAR(191) NULL,
    `name` VARCHAR(191) NOT NULL,
    `model` JSON NOT NULL,
    `metadata` JSON NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,
    `deletedAt` DATETIME(3) NULL,

    INDEX `survey_organizationId_fkey`(`organizationId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `collector` (
    `id` VARCHAR(191) NOT NULL,
    `organizationId` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `showDemographicForm` BOOLEAN NOT NULL,
    `openAt` DATETIME(3) NULL,
    `closeAt` DATETIME(3) NULL,
    `report` JSON NULL,
    `reportedAt` DATETIME(3) NULL,
    `metadata` JSON NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,
    `deletedAt` DATETIME(3) NULL,

    INDEX `collector_organizationId_fkey`(`organizationId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `respondent` (
    `id` VARCHAR(191) NOT NULL,
    `organizationId` VARCHAR(191) NOT NULL,
    `userId` VARCHAR(191) NOT NULL,
    `collectorId` VARCHAR(191) NOT NULL,
    `surveyId` VARCHAR(191) NULL,
    `parentId` VARCHAR(191) NULL,
    `group` VARCHAR(191) NULL,
    `cohort` VARCHAR(191) NULL,
    `recordPath` JSON NULL,
    `response` JSON NULL,
    `startedAt` DATETIME(3) NULL,
    `endedAt` DATETIME(3) NULL,
    `report` JSON NULL,
    `reportedAt` DATETIME(3) NULL,
    `age` VARCHAR(191) NULL,
    `gender` VARCHAR(191) NULL,
    `maritalStatus` VARCHAR(191) NULL,
    `race` VARCHAR(191) NULL,
    `education` VARCHAR(191) NULL,
    `country` VARCHAR(191) NULL,
    `state` VARCHAR(191) NULL,
    `workLocation` VARCHAR(191) NULL,
    `metadata` JSON NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,
    `deletedAt` DATETIME(3) NULL,

    INDEX `respondent_age_idx`(`age`),
    INDEX `respondent_gender_idx`(`gender`),
    INDEX `respondent_maritalStatus_idx`(`maritalStatus`),
    INDEX `respondent_race_idx`(`race`),
    INDEX `respondent_education_idx`(`education`),
    INDEX `respondent_country_idx`(`country`),
    INDEX `respondent_state_idx`(`state`),
    INDEX `respondent_workLocation_idx`(`workLocation`),
    INDEX `respondent_organizationId_fkey`(`organizationId`),
    INDEX `respondent_parentId_fkey`(`parentId`),
    INDEX `respondent_surveyId_fkey`(`surveyId`),
    INDEX `respondent_userId_fkey`(`userId`),
    UNIQUE INDEX `respondent_collectorId_userId_key`(`collectorId`, `userId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `_CollectorToSurvey` (
    `A` VARCHAR(191) NOT NULL,
    `B` VARCHAR(191) NOT NULL,

    UNIQUE INDEX `_CollectorToSurvey_AB_unique`(`A`, `B`),
    INDEX `_CollectorToSurvey_B_index`(`B`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `user` ADD CONSTRAINT `user_organizationId_fkey` FOREIGN KEY (`organizationId`) REFERENCES `organization`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `survey` ADD CONSTRAINT `survey_organizationId_fkey` FOREIGN KEY (`organizationId`) REFERENCES `organization`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `collector` ADD CONSTRAINT `collector_organizationId_fkey` FOREIGN KEY (`organizationId`) REFERENCES `organization`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `respondent` ADD CONSTRAINT `respondent_collectorId_fkey` FOREIGN KEY (`collectorId`) REFERENCES `collector`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `respondent` ADD CONSTRAINT `respondent_organizationId_fkey` FOREIGN KEY (`organizationId`) REFERENCES `organization`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `respondent` ADD CONSTRAINT `respondent_parentId_fkey` FOREIGN KEY (`parentId`) REFERENCES `respondent`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `respondent` ADD CONSTRAINT `respondent_surveyId_fkey` FOREIGN KEY (`surveyId`) REFERENCES `survey`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `respondent` ADD CONSTRAINT `respondent_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `user`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `_CollectorToSurvey` ADD CONSTRAINT `_CollectorToSurvey_A_fkey` FOREIGN KEY (`A`) REFERENCES `collector`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `_CollectorToSurvey` ADD CONSTRAINT `_CollectorToSurvey_B_fkey` FOREIGN KEY (`B`) REFERENCES `survey`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
