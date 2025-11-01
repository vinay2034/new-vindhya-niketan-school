-- Migration to add createdBy column to classes and subjects tables

-- Add createdBy to classes table
ALTER TABLE classes 
ADD COLUMN createdBy INT DEFAULT NULL,
ADD CONSTRAINT fk_classes_createdBy FOREIGN KEY (createdBy) REFERENCES users(id) ON DELETE SET NULL;

-- Add createdBy to subjects table  
ALTER TABLE subjects
ADD COLUMN createdBy INT DEFAULT NULL,
ADD CONSTRAINT fk_subjects_createdBy FOREIGN KEY (createdBy) REFERENCES users(id) ON DELETE SET NULL;
