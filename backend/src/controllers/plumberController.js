const PlumberTask = require('../models/PlumberTask');
const Product = require('../models/Product');
const User = require('../models/User');
const ApiResponse = require('../utils/apiResponse');
const { TASK_STATUSES } = require('../utils/constants');

/**
 * Plumber Dashboard Summary
 */
exports.getDashboardSummary = async (req, res, next) => {
  try {
    const plumberId = req.user._id;

    const assignedCount = await PlumberTask.countDocuments({
      plumber: plumberId,
      status: TASK_STATUSES.ASSIGNED,
    });

    const inProgressCount = await PlumberTask.countDocuments({
      plumber: plumberId,
      status: TASK_STATUSES.IN_PROGRESS,
    });

    const completedCount = await PlumberTask.countDocuments({
      plumber: plumberId,
      status: TASK_STATUSES.COMPLETED,
    });

    const recentTasks = await PlumberTask.find({ plumber: plumberId })
      .sort({ createdAt: -1 })
      .limit(5);

    return ApiResponse.success(res, 'Plumber dashboard summary', {
      profile: {
        name: req.user.name,
        mobileNumber: req.user.mobileNumber,
        rating: req.user.plumberRating || 4.8,
        certificationNo: req.user.plumberCertificationNo || 'PLM-9021',
        verificationStatus: req.user.plumberVerificationStatus || 'verified',
        isAvailable: req.user.isAvailable ?? true,
      },
      stats: {
        assigned: assignedCount,
        inProgress: inProgressCount,
        completed: completedCount,
        totalEarningsThisMonth: completedCount * 750,
      },
      recentTasks,
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Get Assigned Tasks / Activities
 */
exports.getAssignedTasks = async (req, res, next) => {
  try {
    const { status } = req.query;
    const filter = { plumber: req.user._id };

    if (status && status !== 'all') {
      filter.status = status;
    }

    const tasks = await PlumberTask.find(filter).sort({ scheduledDate: 1 });
    return ApiResponse.success(res, 'Plumber assigned tasks fetched', tasks);
  } catch (error) {
    next(error);
  }
};

/**
 * Update Task Status (e.g., mark in progress or completed)
 */
exports.updateTaskStatus = async (req, res, next) => {
  try {
    const { taskId } = req.params;
    const { status, completionNotes, sparePartsUsed } = req.body;

    const task = await PlumberTask.findOne({
      _id: taskId,
      plumber: req.user._id,
    });

    if (!task) {
      return ApiResponse.error(res, 'Assigned task not found', 404);
    }

    if (status) task.status = status;
    if (completionNotes) task.completionNotes = completionNotes;
    if (sparePartsUsed) task.sparePartsUsed = sparePartsUsed;

    await task.save();

    return ApiResponse.success(res, 'Task updated successfully', task);
  } catch (error) {
    next(error);
  }
};

/**
 * Get Plumber Recommended Products & Plumbing Catalog
 */
exports.getPlumberProducts = async (req, res, next) => {
  try {
    const products = await Product.find({ isActive: true })
      .select('name sku category price unit imageUrl specifications')
      .limit(15);

    return ApiResponse.success(res, 'Recommended plumbing supplies fetched', products);
  } catch (error) {
    next(error);
  }
};

/**
 * Get Plumber Notifications
 */
exports.getNotifications = async (req, res, next) => {
  try {
    const notifications = [
      {
        id: 'NOTIF-01',
        title: 'New Service Activity Assigned',
        message: 'You have been assigned to pipeline leakage at Green Park Society, Flat 402.',
        type: 'task_assigned',
        timestamp: new Date(Date.now() - 30 * 60 * 1000),
      },
      {
        id: 'NOTIF-02',
        title: 'Certification Renewal Alert',
        message: 'Your Zoho Verified Plumber credential was reviewed and verified for FY26.',
        type: 'verification',
        timestamp: new Date(Date.now() - 24 * 60 * 60 * 1000),
      },
      {
        id: 'NOTIF-03',
        title: 'Piping Specification Guide',
        message: 'Updated CPVC flow dynamics manual has been added to the knowledge center.',
        type: 'info',
        timestamp: new Date(Date.now() - 48 * 60 * 60 * 1000),
      },
    ];

    return ApiResponse.success(res, 'Plumber notifications', notifications);
  } catch (error) {
    next(error);
  }
};
