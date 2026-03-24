import { Router } from 'express';
import { verifyToken, requireAdmin } from '../middleware/auth';
import * as courseController from '../controllers/course.controller';

const router = Router();

// ========== ROTAS PÚBLICAS ==========

// Listar cursos com módulos e aulas (público)
router.get('/courses', courseController.listCoursesPublic);

// Buscar curso específico (público)
router.get('/courses/:id', courseController.getCoursePublic);

// ========== ROTAS ADMIN - CURSOS ==========

router.get('/admin/courses', verifyToken, requireAdmin, courseController.listCoursesAdmin);
router.post('/admin/courses', verifyToken, requireAdmin, courseController.createCourse);
router.put('/admin/courses/:id', verifyToken, requireAdmin, courseController.updateCourse);
router.delete('/admin/courses/:id', verifyToken, requireAdmin, courseController.deleteCourse);

// ========== ROTAS ADMIN - MÓDULOS ==========

router.get('/admin/courses/modules', verifyToken, requireAdmin, courseController.listModules);
router.post('/admin/courses/modules', verifyToken, requireAdmin, courseController.createModule);
router.put('/admin/courses/modules/:id', verifyToken, requireAdmin, courseController.updateModule);
router.delete('/admin/courses/modules/:id', verifyToken, requireAdmin, courseController.deleteModule);

// ========== ROTAS ADMIN - LIÇÕES ==========

router.post('/admin/courses/lessons', verifyToken, requireAdmin, courseController.createLesson);
router.put('/admin/courses/lessons/:id', verifyToken, requireAdmin, courseController.updateLesson);
router.delete('/admin/courses/lessons/:id', verifyToken, requireAdmin, courseController.deleteLesson);

export default router;
