import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';

class ManageClassesSubjects extends StatefulWidget {
  const ManageClassesSubjects({super.key});

  @override
  State<ManageClassesSubjects> createState() => _ManageClassesSubjectsState();
}

class _ManageClassesSubjectsState extends State<ManageClassesSubjects> {
  final TextEditingController _classNameController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();

  final TextEditingController _subjectNameController = TextEditingController();
  int? selectedClassIdForSubject;

  List<dynamic> existingClasses = [];
  List<dynamic> subjects = [];
  bool isLoading = true;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdminRole();
    _loadData();
  }

  Future<void> _checkAdminRole() async {
    final adminStatus = await AuthService.isAdmin();
    setState(() {
      isAdmin = adminStatus;
    });
  }

  @override
  void dispose() {
    _classNameController.dispose();
    _sectionController.dispose();
    _subjectNameController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    try {
      print('📥 Loading classes and subjects...');
      final classesData = await ApiService.getAllClasses();
      final subjectsData = await ApiService.getAllSubjects();
      print('📊 Loaded ${classesData.length} classes and ${subjectsData.length} subjects');
      print('📋 Classes: $classesData');
      setState(() {
        existingClasses = classesData;
        subjects = subjectsData;
        isLoading = false;
      });
      print('✅ Data loaded successfully and UI updated');
    } catch (e) {
      print('❌ Error loading data: $e');
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    }
  }

  Future<void> _createClass() async {
    if (_classNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter class name'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
              SizedBox(width: 16),
              Text('Creating class...'),
            ],
          ),
          duration: Duration(seconds: 2),
        ),
      );

      // Use class name as grade (simplified)
      await ApiService.createClass(
        name: _classNameController.text.trim(),
        grade: _classNameController.text.trim(),
        section: _sectionController.text.trim().isNotEmpty ? _sectionController.text.trim() : null,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Class created successfully!'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
      
      _classNameController.clear();
      _sectionController.clear();
      await _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text('Failed to create class: ${e.toString()}')),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<void> _createSubject() async {
    if (selectedClassIdForSubject == null || _subjectNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a class and enter subject name'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
              SizedBox(width: 16),
              Text('Creating subject...'),
            ],
          ),
          duration: Duration(seconds: 2),
        ),
      );

      // Auto-generate subject code from subject name (e.g., "Mathematics" -> "MATHEM")
      String autoCode = _subjectNameController.text.trim().toUpperCase();
      if (autoCode.length > 6) {
        autoCode = autoCode.substring(0, 6);
      }
      
      await ApiService.createSubject(
        name: _subjectNameController.text.trim(),
        classId: selectedClassIdForSubject!,
        code: autoCode,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Subject created successfully!'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
      
      _subjectNameController.clear();
      setState(() {
        selectedClassIdForSubject = null;
      });
      await _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text('Failed to create subject: ${e.toString()}')),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<void> _deleteClass(int classId, String className) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Class'),
        content: Text('Delete $className?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        await ApiService.deleteClass(classId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Class deleted')));
        }
        _loadData();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  Future<void> _deleteSubject(int subjectId, String subjectName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Subject'),
        content: Text('Delete $subjectName?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        await ApiService.deleteSubject(subjectId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Subject deleted')));
        }
        _loadData();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: const Text('Manage Classes & Subjects', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCreateClassSection(),
                      const SizedBox(height: 32),
                      _buildExistingClassesSection(),
                      const SizedBox(height: 32),
                      _buildCreateSubjectSection(),
                      const SizedBox(height: 32),
                      _buildExistingSubjectsSection(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildCreateClassSection() {
    if (!isAdmin) {
      return const SizedBox.shrink(); // Hide for non-admin users
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Create New Class', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              TextField(
                controller: _classNameController,
                decoration: InputDecoration(
                  labelText: 'Class Name *',
                  hintText: 'e.g., LKG, UKG, Grade 1',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _sectionController,
                decoration: InputDecoration(
                  labelText: 'Section (Optional)',
                  hintText: 'e.g., A, B, C',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _createClass,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9C27B0),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Create Class', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExistingClassesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Existing Classes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('${existingClasses.length} classes', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
        const SizedBox(height: 16),
        if (existingClasses.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text('No classes yet', style: TextStyle(color: Colors.grey[600]))),
          )
        else
          ...existingClasses.map((c) => _buildClassCard(c)),
      ],
    );
  }

  Widget _buildClassCard(dynamic classData) {
    final subjectsList = classData['subjects'] as List? ?? [];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 3)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(classData['name'] ?? 'Unnamed', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    Text('Grade: ${classData['grade'] ?? 'N/A'}', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                  ],
                ),
              ),
              if (isAdmin)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _deleteClass(classData['id'], classData['name']),
                  color: Colors.red[400],
                ),
            ],
          ),
          if (subjectsList.isNotEmpty) ...[
            const Divider(),
            Wrap(
              spacing: 8,
              children: subjectsList.map((s) => Chip(label: Text(s['name'] ?? 'N/A', style: const TextStyle(fontSize: 12)), backgroundColor: Colors.purple[50])).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCreateSubjectSection() {
    if (!isAdmin) {
      return const SizedBox.shrink(); // Hide for non-admin users
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Create New Subject', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              if (existingClasses.isEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange[700]),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Please create a class first before adding subjects',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                )
              else
                DropdownButtonFormField<int>(
                  value: selectedClassIdForSubject,
                  decoration: InputDecoration(
                    labelText: 'Class Name *',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  items: existingClasses.map((c) => DropdownMenuItem<int>(value: c['id'], child: Text(c['name'] ?? 'Unnamed'))).toList(),
                  onChanged: (v) => setState(() => selectedClassIdForSubject = v),
                ),
              if (existingClasses.isNotEmpty) const SizedBox(height: 12),
              if (existingClasses.isNotEmpty)
                TextField(
                  controller: _subjectNameController,
                  decoration: InputDecoration(
                    labelText: 'Subject Name *',
                    hintText: 'e.g., Mathematics, Science',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onChanged: (value) {
                    setState(() {}); // Trigger rebuild to update code preview
                  },
                ),
              if (existingClasses.isNotEmpty) const SizedBox(height: 12),
              if (existingClasses.isNotEmpty)
                TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Subject Code (Auto-generated)',
                    hintText: _subjectNameController.text.isEmpty 
                        ? 'Will be generated from subject name'
                        : _subjectNameController.text.toUpperCase().substring(0, _subjectNameController.text.length > 6 ? 6 : _subjectNameController.text.length),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              if (existingClasses.isNotEmpty) const SizedBox(height: 16),
              if (existingClasses.isNotEmpty)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _createSubject,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9C27B0),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Create Subject', style: TextStyle(color: Colors.white)),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExistingSubjectsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Existing Subjects', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('${subjects.length} subjects', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
        const SizedBox(height: 16),
        if (subjects.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text('No subjects yet', style: TextStyle(color: Colors.grey[600]))),
          )
        else
          ...subjects.map((s) => _buildSubjectCard(s)),
      ],
    );
  }

  Widget _buildSubjectCard(dynamic subject) {
    final classInfo = subject['class'];
    final teacherInfo = subject['teacher'];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 3)],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject['name'] ?? 'Unnamed', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                if (subject['code'] != null) Text('Code: ${subject['code']}', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                Text('Class: ${classInfo?['name'] ?? 'N/A'}', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                if (teacherInfo != null) Text('Teacher: ${teacherInfo['name'] ?? 'N/A'}', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
              ],
            ),
          ),
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _deleteSubject(subject['id'], subject['name']),
              color: Colors.red[400],
          ),
        ],
      ),
    );
  }
}
