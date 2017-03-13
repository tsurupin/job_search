import React, { PropTypes } from 'react';
import { FavoriteJobRow } from 'components';

const propTypes = {
  favoriteJobs: PropTypes.array.isRequired,
  handleRemove: PropTypes.func.isRequired,
  handleUpdate: PropTypes.func.isRequired
};

const FavoriteJobTable = ({favoriteJobs, handleRemove, handleUpdate}) =>{

  return (
    <table>
      {renderFavoriteJobRows(favoriteJobs, handleRemove, handleUpdate)}
    </table>
  )
};

function renderFavoriteJobRows(jobs, remove, update) {
  console.log(jobs)
  return jobs.map((job, index) => {
    const property = {...job, index, handleRemove: remove, handleUpdate: update};
    return <FavoriteJobRow key={job.id} {...property} />
  })
}

FavoriteJobTable.propTypes = propTypes;
export default FavoriteJobTable;