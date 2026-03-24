import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';
import { AuthRequest } from '../middleware/auth';

const prisma = new PrismaClient();

// ============= PÚBLICO =============

export const listCoursesPublic = async (req: Request, res: Response): Promise<void> => {
    try {
        const courses = await prisma.course.findMany({
            where: { status: 'ACTIVE' },
            include: {
                modules: {
                    where: { status: 'ACTIVE' },
                    include: {
                        lessons: {
                            where: { status: 'ACTIVE' },
                            orderBy: { order: 'asc' },
                        },
                    },
                    orderBy: { order: 'asc' },
                },
            },
            orderBy: { order: 'asc' },
        });

        res.json(courses);
    } catch (error) {
        console.error('Error listing courses:', error);
        res.status(500).json({ error: 'Erro ao listar cursos' });
    }
};

export const getCoursePublic = async (req: Request, res: Response): Promise<void> => {
    try {
        const id = req.params.id as string;
        const course = await prisma.course.findFirst({
            where: { id, status: 'ACTIVE' },
            include: {
                modules: {
                    where: { status: 'ACTIVE' },
                    include: {
                        lessons: {
                            where: { status: 'ACTIVE' },
                            orderBy: { order: 'asc' },
                        },
                    },
                    orderBy: { order: 'asc' },
                },
            },
        });

        if (!course) {
            res.status(404).json({ error: 'Curso não encontrado' });
            return;
        }

        res.json(course);
    } catch (error) {
        console.error('Error fetching course:', error);
        res.status(500).json({ error: 'Erro ao buscar curso' });
    }
};

// ============= ADMIN - CURSOS =============

export const listCoursesAdmin = async (req: AuthRequest, res: Response): Promise<void> => {
    try {
        const courses = await prisma.course.findMany({
            include: {
                modules: {
                    include: {
                        lessons: {
                            orderBy: { order: 'asc' },
                        },
                    },
                    orderBy: { order: 'asc' },
                },
            },
            orderBy: { order: 'asc' },
        });

        res.json(courses);
    } catch (error) {
        console.error('Error listing courses admin:', error);
        res.status(500).json({ error: 'Erro ao listar cursos' });
    }
};

export const createCourse = async (req: AuthRequest, res: Response): Promise<void> => {
    try {
        const { title, description, thumbnail, order, status } = req.body;

        if (!title) {
            res.status(400).json({ error: 'Título é obrigatório' });
            return;
        }

        const course = await prisma.course.create({
            data: {
                title,
                description: description || null,
                thumbnail: thumbnail || null,
                order: order ? parseInt(order) : 0,
                status: status || 'ACTIVE',
            },
        });

        res.json(course);
    } catch (error) {
        console.error('Error creating course:', error);
        res.status(500).json({ error: 'Erro ao criar curso' });
    }
};

export const updateCourse = async (req: AuthRequest, res: Response): Promise<void> => {
    try {
        const id = req.params.id as string;
        const { title, description, thumbnail, order, status } = req.body;

        const course = await prisma.course.update({
            where: { id },
            data: {
                ...(title && { title }),
                ...(description !== undefined && { description }),
                ...(thumbnail !== undefined && { thumbnail }),
                ...(order !== undefined && { order: parseInt(order) }),
                ...(status && { status }),
            },
        });

        res.json(course);
    } catch (error) {
        console.error('Error updating course:', error);
        res.status(500).json({ error: 'Erro ao atualizar curso' });
    }
};

export const deleteCourse = async (req: AuthRequest, res: Response): Promise<void> => {
    try {
        const id = req.params.id as string;

        // Buscar módulos do curso
        const modules = await prisma.courseModule.findMany({ where: { course_id: id } });

        // Deletar aulas de todos os módulos
        for (const mod of modules) {
            await prisma.courseLesson.deleteMany({ where: { module_id: mod.id } });
        }

        // Deletar módulos
        await prisma.courseModule.deleteMany({ where: { course_id: id } });

        // Deletar curso
        await prisma.course.delete({ where: { id } });

        res.json({ message: 'Curso deletado com sucesso' });
    } catch (error) {
        console.error('Error deleting course:', error);
        res.status(500).json({ error: 'Erro ao deletar curso' });
    }
};

// ============= ADMIN - MÓDULOS =============

export const listModules = async (req: AuthRequest, res: Response): Promise<void> => {
    try {
        const { course_id } = req.query;

        const modules = await prisma.courseModule.findMany({
            where: course_id ? { course_id: course_id as string } : {},
            include: {
                lessons: {
                    orderBy: { order: 'asc' },
                },
            },
            orderBy: { order: 'asc' },
        });

        res.json(modules);
    } catch (error) {
        console.error('Error listing modules:', error);
        res.status(500).json({ error: 'Erro ao listar módulos' });
    }
};

export const createModule = async (req: AuthRequest, res: Response): Promise<void> => {
    try {
        const { course_id, title, description, order } = req.body;

        if (!title) {
            res.status(400).json({ error: 'Título é obrigatório' });
            return;
        }

        const module = await prisma.courseModule.create({
            data: {
                course_id: course_id || null,
                title,
                description: description || null,
                order: order ? parseInt(order) : 0,
                status: 'ACTIVE',
            },
        });

        res.json(module);
    } catch (error) {
        console.error('Error creating module:', error);
        res.status(500).json({ error: 'Erro ao criar módulo' });
    }
};

export const updateModule = async (req: AuthRequest, res: Response): Promise<void> => {
    try {
        const id = req.params.id as string;
        const { course_id, title, description, order, status } = req.body;

        const module = await prisma.courseModule.update({
            where: { id },
            data: {
                ...(course_id !== undefined && { course_id }),
                ...(title && { title }),
                ...(description !== undefined && { description }),
                ...(order !== undefined && { order: parseInt(order) }),
                ...(status && { status }),
            },
        });

        res.json(module);
    } catch (error) {
        console.error('Error updating module:', error);
        res.status(500).json({ error: 'Erro ao atualizar módulo' });
    }
};

export const deleteModule = async (req: AuthRequest, res: Response): Promise<void> => {
    try {
        const id = req.params.id as string;

        await prisma.courseLesson.deleteMany({ where: { module_id: id } });
        await prisma.courseModule.delete({ where: { id } });

        res.json({ message: 'Módulo deletado com sucesso' });
    } catch (error) {
        console.error('Error deleting module:', error);
        res.status(500).json({ error: 'Erro ao deletar módulo' });
    }
};

// ============= ADMIN - LIÇÕES =============

export const createLesson = async (req: AuthRequest, res: Response): Promise<void> => {
    try {
        const { module_id, title, description, youtube_url, order } = req.body;

        if (!module_id || !title || !youtube_url) {
            res.status(400).json({ error: 'Module ID, título e YouTube URL são obrigatórios' });
            return;
        }

        const lesson = await prisma.courseLesson.create({
            data: {
                module_id,
                title,
                description: description || null,
                youtube_url,
                order: order ? parseInt(order) : 0,
                status: 'ACTIVE',
            },
        });

        res.json(lesson);
    } catch (error) {
        console.error('Error creating lesson:', error);
        res.status(500).json({ error: 'Erro ao criar aula' });
    }
};

export const updateLesson = async (req: AuthRequest, res: Response): Promise<void> => {
    try {
        const id = req.params.id as string;
        const { title, description, youtube_url, order, status } = req.body;

        const lesson = await prisma.courseLesson.update({
            where: { id },
            data: {
                ...(title && { title }),
                ...(description !== undefined && { description }),
                ...(youtube_url && { youtube_url }),
                ...(order !== undefined && { order: parseInt(order) }),
                ...(status && { status }),
            },
        });

        res.json(lesson);
    } catch (error) {
        console.error('Error updating lesson:', error);
        res.status(500).json({ error: 'Erro ao atualizar aula' });
    }
};

export const deleteLesson = async (req: AuthRequest, res: Response): Promise<void> => {
    try {
        const id = req.params.id as string;

        await prisma.courseLesson.delete({ where: { id } });

        res.json({ message: 'Aula deletada com sucesso' });
    } catch (error) {
        console.error('Error deleting lesson:', error);
        res.status(500).json({ error: 'Erro ao deletar aula' });
    }
};

// Alias para compatibilidade com rota pública legada
export const listCourses = listCoursesPublic;
