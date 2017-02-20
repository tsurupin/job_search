import React, { PropTypes } from 'react';
import { JobRow } from 'components';

const propTypes = {
  jobs: PropTypes.array.isRequired
};

const JobTable = ({jobs}) =>{
  return (
    <table>
      {jobs.map(job => <JobRow key={job.id} {...job} />)}
    </table>
  )
};

JobTable.propTypes = propTypes;
export default JobTable;