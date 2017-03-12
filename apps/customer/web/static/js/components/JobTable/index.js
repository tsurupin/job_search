import React, { PropTypes } from 'react';
import { JobRow } from 'components';

const propTypes = {
  jobs: PropTypes.array.isRequired,
  handleSwitchFavoriteStatus: PropTypes.func.isRequired
};

const JobTable = ({jobs, handleSwitchFavoriteStatus}) =>{

  return (
    <table>
      {renderJobRows(jobs, handleSwitchFavoriteStatus)}
    </table>
  )
};

function renderJobRows(jobs, fnc) {
  console.log(jobs)
  return jobs.map((job, index) => {
    const property = {...job, index, handleSwitchFavoriteStatus: fnc};
    return <JobRow key={job.id} {...property} />
  })
}

JobTable.propTypes = propTypes;
export default JobTable;