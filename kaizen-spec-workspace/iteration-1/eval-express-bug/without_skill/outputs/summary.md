# Without-Skill Baseline: Express.js 404 Bug Fix

## 1. Clarifying questions asked before writing a fix?
No. Proceeded directly to diagnosis and fix without asking:
- What ORM is in use (Mongoose, Sequelize, Prisma, raw SQL)?
- What does the current route handler look like?
- What test framework is in place?
- What should the 404 response body look like?

## 2. Failing test first, or fix first?
**Fix first.** No red-green cycle. Assumed fix written immediately:
```js
router.get('/users/:id', async (req, res) => {
  const user = await User.findById(req.params.id);
  if (!user) return res.status(404).json({ error: 'User not found' });
  res.json(user);
});
```
Test written after the fix - cannot prove the bug existed before, may not match actual codebase.

## 3. How would the user know the fix is correct?
They largely would not. No:
- Failing test pinning the bug before fix
- Green test run confirming regression resolved
- Coverage of edge cases (malformed ID, DB errors, soft-deleted users)
- Agreed acceptance criteria before work started

## 4. What was produced?
- Generic assumed fix (no actual files read)
- A single assumed test written post-fix
- No test framework confirmation, no red-green cycle, no acceptance gate
