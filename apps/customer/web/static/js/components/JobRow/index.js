import React, { PropTypes } from 'react';

const propTypes = {
  id: PropTypes.number.isRequired,
  jobTitle: PropTypes.string.isRequired,
  area: PropTypes.string.isRequired,
  updatedAt: PropTypes.string.isRequired,
  techs: PropTypes.array.isRequired
};

const JobRow = ({ id, jobTitle, area, updatedAt, techs }) =>{
  return (
    <tr>
      <p>{jobTitle}</p>
    </tr>
  )
};

JobRow.propTypes = propTypes;
export default JobRow;